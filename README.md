# git-ver

Yet another set of bash utilities to help with semantic versioning.

## Motivation

I wanted a highly portable tool with no dependency on tools outside of git. In searching the web I found nothing that suited my needs.

### Why bash?

It's a shell that I use on Windows and of course Linux. It's also supported on macOS. Many CI/CD tools are built on `docker`, and therefore, by default, Linux.

### Why not just use GitVersion?

I really wanted to, but given that it requires Mono on non-Windows Operating Systems, it's quite the heavyweight to install correctly at the start-up of a container. And since the project I was doing this for is .Net Core, I eschewed putting both tools on the same container, yet I wanted functionality similar to GitVersion. That meant I had to write it.

## Usage

`usage: git-ver [command] [command arguments]`

For more details on the individual commands type `git-ver help [command]`

### List of commands:

`get-major` : Returns the major number from the current semantic version number. (Major.Minor.Patch[-info+metadata])

`get-minor` : Returns the minor number from the current semantic version number.

`get-patch` : Returns the patch number from the current semantic version number

`get-prefix` : Returns the version with a prefix, prefix defaults to 'v'

`get-rev` : Counts the number of commits from the last tag and returns that as a revision number. (placed in info as _info_**#**)

`get-semver` : Retrieves a full semantic version, optionally with metadata (+r1; +dYYYYMMDD-hhmmss)

`get-suffix` : gets the suffix for a pre-release semantic version. (e.g. -alpha1)

`get-version` : Gets the version number in Major.Minor.Patch format

`show-locations` : Displays the list of directories in use by `git-ver`.

`version` or `--version` : Displays the version of `git-ver`.

`help` : Displays this help information.
