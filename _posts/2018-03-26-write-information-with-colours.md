---
title: Write-Information With Colours
tags:
    - Powershell
    - Sitecore Install Framework
classes: ''
toc: true
toc_label: In This Post
---

When learning PowerShell, one of the first things you learn is that the command
`Write-Host` is super useful.  It lets you write messages to the console and
allows you to specify optional foreground and background colors.

However, the very next thing you learn is:
> Don't use `Write-Host` - it can't be suppressed or redirected.

So how do you write messages to the user?

## `Write-Information`

In PowerShell 5, a new stream was introduced.  PowerShell already had Verbose,
Debug, Warning, Error, and Output streams, but it was now time to add an
_Information_ stream. Ed Wilson has a great write-up on its introduction
[here][1].

### Why?
One of the key problems with `Write-Host` is that it goes directly to the host
implementation.  There it is consumed and effectively 'lost' to the user.
By introducing `Write-Information` and the new stream, users
can now redirect the stream and modify its impact using `$InformationPreference`
and the common parameter `-InformationAction` for cmdlets.

{% gist 90ff3b32f4645577a1f201f3092300bd Write-InformationExample.ps1 %}

With the new stream available, the implementation of `Write-Host` was then changed
to _redirect_ to `Write-Information`.  To make the changes non-breaking the `-InformationAction` is always treated as `Continue` to ensure that
existing uses of `Write-Host` continue to display as they did in previous
versions of PowerShell.

This means:
> If a cmdlet calls `Write-Host` the user can never hide that message from the console.

For example, all of these messages are still displayed even when attempting to
use `$InformationPreference` and `-InformationAction`

{% gist 90ff3b32f4645577a1f201f3092300bd Write-HostExample.ps1 %}

### But what about colors?

However, `Write-Host` supports `-ForegroundColor` and `-BackgroundColor` but `Write-Information` does not. People continue to use
`Write-Host` and in doing so they continue to prevent the user from using
`$InformationPreference` and `-InformationAction` as intended.

## How is `Write-Host` implemented?

So how can we use the information stream _and_ also have colours?  Let's take a
look at the source code to see how `Write-Host` is now implemented.

> **NOTE**: This isn't the _actual_ Windows PowerShell version of the code, but
by checking the PowerShell Core implementation we should get a handle on how
things currently work as well as how things work in the future.

The full implementation of `Write-Host` can be seen [here][2].  We're actually
just interested in the [implementation][5] of `ProcessRecord`.

What we can see is the construction of a `HostInformationMessage` object
containing the parameters from the cmdlet.  This is then passed on to `WriteInformation`
along with a tag of `PSHOST`.

Taking a look at the [implementation][3] for `Write-Information`  we can see that the tags are checked to see if the the `PSHOST` tag is provided and a tag of
`FORWARDED` is missing **or** the current information preference is `Continue`.
In the event that this check is passed, the `MessageData` of the current record
is tested as a `HostInformationMessage` and if found, the message is then
decomposed and its values used to communicate to the host.

Before all of these checks, there is a call to `CBhost.InternalUI.WriteInformationRecord(record);` where (I assume...) the normal writing of the record occurs.

From this information we now understand:
+ When calling `Write-Host` the parameters are packed up and passed to
`Write-Information` as a `HostInformationMessage`
+ `Write-Information` will process the parameters as a special type _if_
    + A tag of `PSHOST` exists **and** a tag of `FORWARDED` does not
    + **or** The current preference variable is `Continue`

We can therefore conclude:
> Passing a `HostInformationMessage` with no `PSHOST` tag will ensure only the
preference variable impacts visibility.

## `Write-InformationColored`

Taking everything we've learnt so far, we can now build a function that will
support user-specified colours when viewed in a console, but also honour the
visibility of the information stream:

{% gist 90ff3b32f4645577a1f201f3092300bd Write-InformationColored.ps1 %}

By using the new function, we get all the benefits of the information stream
and its associated preference variable _as well as_ the simple coloured output
that `Write-Host` also supports.

{% gist 90ff3b32f4645577a1f201f3092300bd Write-InformationColoredExample.ps1 %}

----
You can grab all the examples from this post [here][4]

[1]: https://blogs.technet.microsoft.com/heyscriptingguy/2015/07/04/weekend-scripter-welcome-to-the-powershell-information-stream/
[2]: https://github.com/PowerShell/PowerShell/blob/master/src/Microsoft.PowerShell.Commands.Utility/commands/utility/WriteConsoleCmdlet.cs
[3]: https://github.com/PowerShell/PowerShell/blob/1b3c8aca507de2984cb14f0780dde94d977c7b8d/src/System.Management.Automation/engine/MshCommandRuntime.cs#L717
[4]:https://gist.github.com/Kieranties/90ff3b32f4645577a1f201f3092300bd
[5]:https://github.com/PowerShell/PowerShell/blob/e86fea6acd508297646e307ffeae2340d0bafaa8/src/Microsoft.PowerShell.Commands.Utility/commands/utility/WriteConsoleCmdlet.cs#L120