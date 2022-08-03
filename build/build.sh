#!/bin/bash
BUILD_SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
SRC_DIR=$(realpath "$BUILD_SCRIPT_DIR/../src")
LIBS_DIR="$SRC_DIR/.git-ver"
bash "$SRC_DIR/git-ver" get-version bump patch > "$LIBS_DIR/VERSION.REPO"
bash "$SRC_DIR/git-ver" get-semver bump patch > "$LIBS_DIR/VERSION"