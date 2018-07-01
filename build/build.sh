#!/bin/bash
export BUILD_SCRIPT_DIR=$(dirname $(readlink -f $0))
$BUILD_SCRIPT_DIR/../src/git-ver get-version bump patch > $BUILD_SCRIPT_DIR/../repo.version
$BUILD_SCRIPT_DIR/../src/git-ver get-semver bump patch > $BUILD_SCRIPT_DIR/../src/git-ver.version