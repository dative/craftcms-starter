#!/bin/bash

# -- GLOBAL Variables --

DDEV_PATH=${DDEV_PATH:-".ddev"}
CRAFT_PATH=${CRAFT_PATH:-"cms"}
SRC_PATH=${SRC_PATH:-"src"}
GITHUB_PATH=${GITHUB_PATH:-".github"}
DEFAULT_SITE_NAME=${DEFAULT_SITE_NAME:-"Dative Boilerplate"}
ADMIN_USERNAME=${ADMIN_USERNAME:-"info@hellodative.com"}
PROJECT_ROOT=${PROJECT_ROOT:-"$PWD"}
TASKS_DIR=${TASKS_DIR:-".bin"}
SCRIPT_OUTPUT=${SCRIPT_OUTPUT:-}

PROJECT_TEST_NAME="local-test"

# -- Functions --

raise() {
    echo "${1}" >&2
}

get_arg_value () {
    if [ -z "$1" ]; then
        raise "Error: arg_name parameter is required."
        return 1
    fi
    
    arg_name="$1"
    args_string="$2"
    
    arg_value=$(echo "$args_string" | tr ' ' '\n' | grep "^$arg_name=" | sed "s/^$arg_name=//")
    echo "$arg_value"
}

remove_from_args() {
    arg_name="$1"
    args_string="$2"
    new_args_string=""
    for arg in $args_string; do
        case "$arg" in
            "$arg_name="*)
                # Do not add the argument to the new_args_string
            ;;
            "$arg_name")
                # Do not add the argument to the new_args_string
            ;;
            *)
                new_args_string="$new_args_string $arg"
            ;;
        esac
    done
    echo "${new_args_string# }"  # Remove leading space
}

check_if_args_unique () {
    if [ -z "$1" ]; then
        return 0
    fi
    
    local args_list=$(echo "$1" | tr ' ' '\n' | sort)
    # get the option names
    local args_option_names=$(echo "$args_list" | cut -d '=' -f 1)
    # get the duplicate names
    local duplicates=$(echo "$args_option_names" | uniq -d)
    if [ -n "$duplicates" ]; then
        raise "Error: Duplicate options found: $duplicates"
        return 1
    fi
}

check_required_environment() {
    local required_env="$1"
    
    for reqvar in $required_env
    do
        if [ -z ${!reqvar} ]
        then
            raise "missing ENVIRONMENT ${reqvar}!"
            return 1
        fi
    done
}

check_required_ddev_command() {
    if ! command -v ddev >/dev/null 2>&1; then
        raise "DDEV not found. Please install DDEV first.";
        return 1;
    fi
}

ddev_up() {
    if [ ! "$(ddev describe | grep OK)" ]; then
        ddev start;
    else
        echo "\033[34mDDEV is already running.\033[0m";
    fi
}

make_output() {
    # [ -z "$SCRIPT_OUTPUT" ] && echo "Empty" || echo "Not empty"
    if [ -z "$SCRIPT_OUTPUT" ]; then
        SCRIPT_OUTPUT="$1";
    else
        SCRIPT_OUTPUT="$SCRIPT_OUTPUT\n$1";
    fi
}

print_output() {
    if [ ! -z "$SCRIPT_OUTPUT" ]; then
        echo "\n*******************************************************************************\n";
        
        # Print the output of the script, indented
        echo "$SCRIPT_OUTPUT" | sed 's/^/    /' |
        # Remove color codes
        sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" |
        # Format to 76 columns
        fmt -w 76;
        
        echo "\n*******************************************************************************\n";
    fi
}
