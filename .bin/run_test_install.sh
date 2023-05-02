#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

# check if PROJECT_TEST_NAME exists, if not create it
if [ -d "$PROJECT_TEST_NAME" ]; then
    make_output "    \033[32mLocal test setup already exists!\033[0m\n";
else
    mkdir $PROJECT_TEST_NAME
    make_output "    \033[32mLocal test setup completed!\033[0m\n";
fi

# # Copy the Makefile and the .bin directory to PROJECT_TEST_NAME
cp Makefile $PROJECT_TEST_NAME
cp -r .bin $PROJECT_TEST_NAME

make_output "    To run the install, run the following:\n";
make_output "    cd $PROJECT_TEST_NAME && make setup-project";

print_output