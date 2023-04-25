#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

copy_config_files() {
    # Copy .boilerplate/buildchain/template.* to tmp directory
    mkdir $DIR/tmp;
    cp $DIR/buildchain/template.* $DIR/tmp;
    cd $DIR/tmp;
    # Remove the "template." prefix from the template.* files
    for file in template.*; do mv "$file" "${file#template.}";done;
    cd $PROJECT_ROOT
    rsync -ur $DIR/tmp/. $PROJECT_ROOT;
    rm -rf $DIR/tmp;
}

check_ddev_command
# --- START OF BUILDCHAIN SETUP ---
if [ -d "$SRC_PATH" ]; then
    echo "\033[33mThe src directory already exists. Skipping Buildchain setup...\033[0m";
    exit 0
fi

echo "Copying $DIR/buildchain/src to $SRC_PATH";
rsync -ur $DIR/buildchain/src/. $SRC_PATH/;

copy_config_files

ddev_up;

# Install NPM dependencies
ddev yarn;

make_output "    \033[32mBuildchain successfully set up!\033[0m\n";
make_output "    To start development run this command:\n";
make_output "    ddev yarn start";


print_output
