#!/bin/bash
set -e

# get the directory this script is executing from.
THIS_DIR=$(dirname "$(readlink -f "$0")")
DEST_DIR="$1"

# check if the user specified a destination path. If not notify the user that ~/bin will be used.
[ "$DEST_DIR" == "" ] && echo "No directory specified, assuming ~/bin" && DEST_DIR=~/bin

# check if the destination exists, warn then exit with an error code if not.
[ ! -d $DEST_DIR ] && echo "Directory $DEST_DIR DOES NOT exist. Aborting." && exit 1

# check if the destination directory is in the PATH
case :$PATH: # notice colons around the value
  in *:$DEST_DIR:*) ;; # do nothing, it's there
     *) # warn the user that the destination isn't in the PATH
        echo "WARNING: '$DEST_DIR' is not currently in your PATH."
        echo "You will need to add it to your PATH before being able to execute the scripts."
        while true; do
          # Prompt to continue or exit. Only accept Y/N/Yes/No (enter is considered N) as answers.
          read -r -p "Do you want to continue [yN]?" yn
          case $yn in
              # Yes specified. Break from the loop.
              [Yy]|[Yy][Ee][Ss]) echo "'Yes' selected. Proceeding with the installation to '$DEST_DIR'" && break;;

              # "No" or ENTER specified. Exit.
              [Nn]|[Nn][Oo]|"") echo "'No' selected. Exiting." && exit 0;;

              # complain to the user.
              *) echo "Please answer yes or no.";;
          esac
        done
        ;;
esac

# copy the supporting scripts over.
cp -TRv "$THIS_DIR/.git-ver/" "$DEST_DIR/.git-ver/"

# copy the main entrypoint over.
cp "$THIS_DIR/git-ver" "$DEST_DIR"

# make the main entrypoint executable.
chmod u+x "$DEST_DIR/git-ver"

# Announce success
echo "git-ver successfully installed."