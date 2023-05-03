#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

stage_test() {
    local INSTALL_PATH="$1"
    
    if [ -z "$INSTALL_PATH" ]; then
        INSTALL_PATH="$STAGED_NAME"
    fi
    
    # check if INSTALL_PATH exists, if not create it
    if [ -d "$INSTALL_PATH" ]; then
        
        raise "a directory named $INSTALL_PATH already exists!\n" "info";
        return 0
    fi
    mkdir $INSTALL_PATH
    
    # # Copy the Makefile and the .bin directory to INSTALL_PATH
    # cp Makefile $INSTALL_PATH
    # cp -r .bin $INSTALL_PATH
    add_to_summary "Local test setup completed!\n";
    add_to_summary "To run the install, run the following:\n";
    add_to_summary "cd $INSTALL_PATH && make setup-project";
    
    print_summary "success"
}

run_main() {
    stage_test "$1" || exit 1
    exit 0;
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    run_main "$1"
    if [ $? -gt 0 ]
    then
        exit 1
    fi
fi