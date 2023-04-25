#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

# check if TASKS_DIR exists, if so delete it
if [ -d "$TASKS_DIR" ]; then
    echo "Deleting $TASKS_DIR...";
    rm -rf $TASKS_DIR;
fi

# Check if Makefile exists, if so delete it
if [ -f "Makefile" ]; then
    echo "Deleting Makefile...";
    rm Makefile;
fi
