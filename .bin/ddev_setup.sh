#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

ARGS_STRING="$@"

ARGS="$ARGS_STRING"

get_ddev_config_options() {
    
    check_if_args_unique "$ARGS" || exit 1
    
    local PROJECT_NAME=$(get_arg_value "--project-name" "$ARGS")
    local PROJECT_TYPE=$(get_arg_value "--project-type" "$ARGS")
    
    if [[ -z "$PROJECT_NAME" ]]; then
        read -rp "Enter project name: " PROJECT_NAME;
    else
        ARGS=$(remove_from_args "--project-name" "$ARGS")
    fi
    
    if [[ -z "$PROJECT_TYPE" ]]; then
        PROJECT_TYPE="craftcms"
    else
        ARGS=$(remove_from_args "--project-type" "$ARGS")
    fi
    
    ARGS=$(remove_from_args "--auto" "$ARGS")
    
    echo "--project-name="$PROJECT_NAME" --project-type=$PROJECT_TYPE --auto $ARGS"
}

setup_ddev() {
    
    if [ -d "$DDEV_PATH" ]; then
        raise "\033[33mThe $DDEV_PATH directory already exists. Skipping DDEV setup...\033[0m";
        return 0;
    fi
    
    DDEV_CONFIG_ARGS=$(get_ddev_config_options) || exit 1
    
    raise "Setting up DDEV..."
    
    # Copy .boilerplate/ddev to .ddev
    raise "Copying $DIR/ddev to $DDEV_PATH";
    cp -r $DIR/ddev $DDEV_PATH;
    
    # Rename sample.config.m1.yaml to config.m1.yaml if Apple Silicon
    if [ "$(uname -m)" = "arm64" ]; then
        mv $DDEV_PATH/sample.config.m1.yaml $DDEV_PATH/config.m1.yaml
    fi
    
    if error_msg=$(ddev config $DDEV_CONFIG_ARGS 2>&1 >/dev/null); then
        PROJECT_NAME=$(get_arg_value "--project-name" "$DDEV_CONFIG_ARGS")
        make_output "\033[32mProject $PROJECT_NAME created!\033[0m\n";
        make_output "To remove and unlist this project, run this command:\n";
        make_output "ddev stop --unlist $PROJECT_NAME && rm -rf .ddev";
        print_output
        echo "Starting DDEV...";
    else
        make_output "Can't create the project due to the following error:\n";
        make_output "$error_msg\n";
        make_output "Cleaning up and exiting...";
        print_output
        rm -rf .ddev;
        exit 1;
    fi
}

run_main() {
    check_required_environment "DDEV_PATH" || exit 1
    check_required_ddev_command || exit 1
    setup_ddev || exit 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    run_main
    if [ $? -gt 0 ]
    then
        exit 1
    fi
fi