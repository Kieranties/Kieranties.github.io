---
title: Windows Terminal - Themes and Gifs!
tags:
    - Scripting
    - PowerShell
header:
  image: /assets/gifs/gifterm.gif
---

Microsoft has made great strides over the last few years to improve the developer
tool chain; [Visual Studio], [Visual Studio Code] (their [Mac] variants!), [WSL] and
all the work going into open-sourcing frameworks such as [dotnet] and
[PowerShell] have led to renewed enthusiasm when developing on a Windows machine.

Poor old cmd.exe didn't get much love... And it still won't.  Microsoft are now
developing a new [Windows Terminal] application that will support multiple tabs,
font ligatures, emojis, multiple shells, and will also be developed as [open source].

The new terminal stores [configuration] in a `profiles.json` file in the users appdata.
This defines _global_ configuration (such as whether tabs should always be displayed),
_profile_ configuration (e.g. powershell, cmd etc), and colour _schemes_
which can be used across multiple profiles.

I'm a big fan of the [Dracula] theme, so the first thing I did was try to add a new
scheme and configure the PowerShell Core profile to use it.  You can do this by
adding a new entry to the `schemes` array, and then using the value of the schemes
`name` property in the `colorScheme` property of the relevant profile:

```json
{
  "profiles":  [
    {
      // snipped other properties
      "colorScheme":  "Dracula",
      "name":  "PowerShell Core"
      //...
    }
  ],
  "schemes":  [
    {
      "background":  "#282A36",
      "black":  "#21222C",
      "blue":  "#F1FA8C",
      "brightBlack":  "#6272A4",
      "brightBlue":  "#D6ACFF",
      "brightCyan":  "#A4FFFF",
      "brightGreen":  "#69FF94",
      "brightPurple":  "#FF92DF",
      "brightRed":  "#FF6E6E",
      "brightWhite":  "#FFFFFF",
      "brightYellow":  "#FFFFA5",
      "cyan":  "#8BE9FD",
      "foreground":  "#F8F8F2",
      "green":  "#50FA7B",
      "name":  "Dracula",
      "purple":  "#BD93F9",
      "red":  "#FF5555",
      "white":  "#F8F8F2",
      "yellow":  "#F1FA8C"
    }
  ]
}
```
While not completely true to the Dracula theme, this was quick and painless.
So quick, I wondered if changing the properties of the profile could be
automated...

## gifterm.ps1

If you work in an office, one of the most important things you should do when
leaving your desk is **lock your machine**.  This is a simple key-stroke that keeps
your machine secure.  It may seem minor, but it's good practice to lock _any_
device which you are not actively using.

`gifterm.ps1` is a quick and dirty PowerShell script that can be used to remind people
how easily their machine can be breached if they leave it unlocked.

Once invoked, the script will grab the top images from giphy.com for the given
query ('cats' by default) and then update each profile for the new terminal
with a random downloaded gif.  To really hammer things home, it also doesn't
pollute the console, and terminates the active process once complete.  So you
can run it quickly and walk away...

To reduce the number of keystrokes required, I've created a bitly link to the [gist]:

```powershell
PS> iwr bitly.com/gifterm | iex # All cats, all the time
PS> $enf:gifq='swear trek'; iwr bitly.com/gifterm | iex # He's f*%&$d Jim!
```

[Visual Studio]: https://visualstudio.microsoft.com/
[Visual Studio Code]: https://code.visualstudio.com/
[Mac]: https://visualstudio.microsoft.com/vs/mac/
[WSL]: https://docs.microsoft.com/en-us/windows/wsl/install-win10
[dotnet]: https://dotnet.microsoft.com/
[PowerShell]: https://github.com/powershell/powershell
[Windows Terminal]: https://www.microsoft.com/en-us/p/windows-terminal-preview/9n0dx20hk701
[open source]: https://github.com/microsoft/terminal
[configuration]: https://github.com/microsoft/terminal/blob/master/doc/cascadia/SettingsSchema.md
[Dracula]: https://draculatheme.com/
[gist]: https://gist.github.com/Kieranties/e78f8cc26f87c3dec3ab155816bce372
