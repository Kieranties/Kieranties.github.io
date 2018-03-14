<#
    .SYNOPSIS
        Simple environment setup script

    .DESCRIPTION
        Downloads and configures WSL with Ubuntu.

        If you have issues registering, check the `wslconfig`
        command to manage the distros installed.

    .LINK
        https://docs.microsoft.com/en-gb/windows/wsl/install-on-server
        https://docs.microsoft.com/en-us/windows/wsl/wsl-config
#>

#Requires -Version 5.1
#Requires -RunAsAdministrator

param(
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [String]$DownloadPath = (Resolve-Path (Join-Path ~ Downloads))
)

# Ensure feature is enabled
$featureName = 'Microsoft-Windows-Subsystem-Linux'
$feature = Get-WindowsOptionalFeature -FeatureName $featureName -Online
if($feature.State -ne 'Enabled') {
    Write-Information -MessageData "WSL is not enabled - restart will be required" -InformationAction Continue
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -Verbose
}

# Check to see if the distro is already available

# We need output in unicode first as calling wsl commands
$origEncoding = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.Encoding]::Unicode
$distro = (wslconfig /l) |
        Where-Object { $_ -like 'ubuntu*' }
[Console]::OutputEncoding = $origEncoding

if(!$distro){

    Write-Information -MessageData "Expected distro [Ubuntu] is not installed" -InformationAction Continue
    # Install if required
    $app = Get-AppxPackage -Name CanonicalGroupLimited.UbuntuonWindows
    if($app -eq $null){
        Write-Information -MessageData "Installing [Ubuntu]" -InformationAction Continue
        # Download
        $appxPath = Join-Path $DownloadPath 'Ubuntu.appx'
        if(!(Test-Path $appxPath)) {
            Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile $appxPath -UseBasicParsing
        }

        # Install
        Add-AppxPackage -Path $appxPath
    }

    # run the distro for the first install
    ubuntu
}

# Ensure ubuntu is the ditro being used
wslconfig /setdefault ubuntu


Write-Information -MessageData "WSL is configured" -InformationAction Continue