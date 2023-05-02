#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

delete_stage_test() {
    # check if PROJECT_TEST_NAME exists, if not exit
    if [ ! -d "$PROJECT_TEST_NAME" ]; then
        make_output "    \033[31mLocal test setup does not exist!\033[0m\n";
        print_output
        exit 0
    fi
    
    cd ${PROJECT_TEST_NAME} || ( printf "unable to cd to ${PROJECT_TEST_NAME}\n" && exit 1 )
    
    DDEV_PROJNAME=$(ddev describe -j | jq -r '.raw.name');
    
    echo "Deleting ddev project ($DDEV_PROJNAME)...";
    
    ddev delete -Oy ${DDEV_PROJNAME}
    
    cd ..
    
    echo "Deleting ${PROJECT_TEST_NAME} directory...";
    rm -rf ${PROJECT_TEST_NAME}
    
    make_output "    \033[32mLocal test setup deleted!\033[0m\n";
    
    print_output
}

run_main() {
    delete_stage_test || exit 1
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    run_main
    if [ $? -gt 0 ]
    then
        exit 1
    fi
fi