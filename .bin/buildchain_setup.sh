#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

copy_config_files() {
    mkdir $DIR/tmp;
    cp $DIR/buildchain/template.* $DIR/tmp;
    cd $DIR/tmp;
    for file in template.*; do mv "$file" "${file#template.}";done;
    cd $PROJECT_ROOT
    rsync -ur $DIR/tmp/. $PROJECT_ROOT;
    rm -rf $DIR/tmp;
}


setup_buildchain() {
    
    if [ -d "$SRC_PATH" ]; then
        raise "\033[33mThe $SRC_PATH directory already exists. Skipping Buildchain setup...\033[0m";
        return 0;
    fi
    
    echo "Copying $DIR/buildchain/src to $SRC_PATH";
    rsync -ur $DIR/buildchain/src/. $SRC_PATH/;
    
    copy_config_files
    
    make_output "\033[32mBuildchain successfully set up!\033[0m\n";
    
    if [ -d "$DDEV_PATH" ]; then
        ddev_up
        
        # Install NPM dependencies
        ddev yarn
        
        make_output "To start development run this command:\n";
        make_output "ddev yarn start";
        
    else
        make_output "DDEV project not configured. Skipping dependencies installation...";
    fi
    
    print_output
    
    return 0;
    
}

run_main() {
    check_required_environment "SRC_PATH" || exit 1
    check_required_ddev_command || exit 1
    setup_buildchain || exit 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    run_main
    if [ $? -gt 0 ]
    then
        exit 1
    fi
fi