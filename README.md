# R package version bump hooks

This is a very simple implementation to automatically bump R package versions
at each commit, via [git hooks][githooks].

This tool works only when you have a `DESCRIPTION` file under your git root repository,
which should contain a line of version string like:

```
Version: x.y.z.r
```

where `x.y.z` is the standard `MAJOR.MINOR.BUILD` versioning theme, and `.r` is the internal version number automatically
managed by this tool.

Optionally if you have a `Date` string in `DESCRIPTION`:

```
Date: yyyy-mm-dd
```

it will also be updated to the current date.

## Pre-requists 

The tool is implemented in `bash`. It assumes you have the following command tools available:

- `/bin/bash`
- `git`
- `wc`
- `grep`
- `sed`
- `date`

They should come with a standard UNIX(-like) system anyways. Just listing them out here in case.

## Installation

```
cd .git/hooks
ln -s ../../inst/misc/pre-commit.sh pre-commit
ln -s ../../inst/misc/post-commit.sh post-commit
```

## Example usage

Suppose now you have changed something in the repository. You can simply stage & commit your changes
(or, commit all your changes via `-a` option in `git commit`):

```
$ git commit -am "Update README.md"
Version string bumped to revision 12 on 2018-10-06
[master d1ac43d] Update README.md
 Date: Sat Oct 6 05:00:40 2018 -0500
 2 files changed, 12 insertions(+), 2 deletions(-)
Amend current commit to incorporate version bump
[master 8b16a98] Update README.md
 1 file changed, 11 insertions(+), 1 deletion(-)
```

## Make public releases

To make a public release (on github or cran) you should manually edit `DESCRIPTION`, 
change (bump) the standard versioning string `x.y.z` and remove the internal version number `.r`, eg,

```
Date: 2018-10-06
Version: 0.1.0
```

Then commit the change:

```
$ git commit -am "Release version 0.1.0"
[WARNING] Auto-versioning disabled because string 'Version: x.y.z.r' cannot be found in DESCRIPTION file.
[master aab4c47] Release version 0.1.0
 2 files changed, 43 insertions(+), 1 deletion(-)
```

You will now receive a warning message that complains about failure to make auto version bump because 
the version string pattern cannot be found. This is intentional because it is meant to be a public release 
without the `.r` part.

However from now on you'll be warned like this every time you make a commit, unless you manually change the version
string to include internal version numbers so that the hook can take control again. To do this, simply add `.0` to the
current version string,

```
Version: 0.1.0.0
```

The next time you commit you should not see the warning message, and the internal version number should be updated. 

[githooks]: https://githooks.com
