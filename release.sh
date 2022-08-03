#!/bin/bash
# abort on any error.
set -e

# get the location where this script is running from.
THIS_DIR=$(dirname "$(readlink -f "$0")")

# if no destination specified notify the user the current directory will be used.
DEST_DIR="$1"
[ "$DEST_DIR" == "" ] && echo "No destination directory specified, assuming current directory" && DEST_DIR="$THIS_DIR"

# resolve the full destination path.
DEST_DIR=$(realpath "$DEST_DIR")

# read the current app version.
VERSION=$(<"$THIS_DIR/src/.git-ver/VERSION")

# compose the target zip file name
ZIP_FILE_NAME="$DEST_DIR/git-ver_v$VERSION.zip"

# check that zip is actually installed. (intentionally unused results)
# shellcheck disable=SC2034
zip_ver=$(zip -v > /dev/null)
echo "zip detected."

# check that git is actually installed.
git_ver=$(git --version)
echo "$git_ver detected."

# move into the source directory (that's what we zip up!)
pushd "$THIS_DIR/src"

# create the zip file.
echo "creating zip file $ZIP_FILE_NAME"
zip -r "$ZIP_FILE_NAME" .

# apply the tag locally to git.
# this script doesn't push the tag as a safety mechanism.
echo "Adding/resetting version tag v$VERSION"
git tag -f "v$VERSION"

# warn the user that they'll need to manually push the tag
echo "You will need to manually upload the release and push the version tag to GitHub."
echo "       git push origin v$VERSION"
popd
