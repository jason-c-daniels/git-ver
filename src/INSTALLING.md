# Installing `jcd-new` from a zip file.
* First unzip the release you got from GitHub to a location of your choosing.
* Then cd into that directory and execute install.sh

## Example
```bash
# On linux, in the directory you downloaded the zip file to, and with the unzip command already installed.
unzip jcd-new_v0.0.2.zip -d ./jcd-new_v0.0.2
cd jcd-new_v0.0.2

# Install to your personal bin folder, which you already have in your PATH.
bash ./install.sh ~/bin

# Now verify the installation worked. NOTE: This won't work if ~/bin isn't in your PATH.
jcd-new --version
```

# Uninstalling `jcd-new`
Delete the files from the locations listed from running `jcd-new locations`.