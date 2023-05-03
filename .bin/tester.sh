#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

ARGS_STRING="$@"

ARGS="$ARGS_STRING"

run_main() {
    printf "Args: %s\n" "$ARGS";
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    run_main
    if [ $? -gt 0 ]
    then
        exit 1
    fi
fi