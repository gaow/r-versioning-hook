#!/bin/bash
#
# This script will be executed every time you run "git commit". It
# will update the 4th digit of package version by revision number.
#
# To use this script, copy it to the .git/hooks directory of your
# local repository to filename `pre-commit`, and make it executable.
#
set -e
ROOT_DIR=`git rev-parse --show-toplevel`
MSG="[WARNING] Auto-versioning disabled because string 'Version: x.y.z.r' cannot be found in DESCRIPTION file."
GREP_REGEX='^Version: [0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'
SED_REGEX='^Version: \([0-9]*\.[0-9]*\.[0-9]*\)\.[0-9]*'
# `git diff HEAD` shows both staged and unstaged changes
if [[ -z `git diff HEAD` ]] || [[ ! -f $ROOT_DIR/DESCRIPTION ]]; then
    exit 0
elif [[ -z `grep "$GREP_REGEX" $ROOT_DIR/DESCRIPTION` ]]; then
    echo "$MSG"
    exit 0
else
    REV_ID=`git log --oneline | wc -l`
    REV_ID=`printf "%04d\n" $((REV_ID+1))`
    DATE=`date +%Y-%m-%d`
    echo "Version string bumped to revision $REV_ID on $DATE"
    sed -i "s/$SED_REGEX/Version: \1.$REV_ID/" $ROOT_DIR/DESCRIPTION
    sed -i "s/^Date: .*/Date: $DATE/" $ROOT_DIR/DESCRIPTION
    exit 0
fi
