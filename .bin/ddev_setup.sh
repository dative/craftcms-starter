#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

check_ddev_command

if [ -d "$DDEV_PATH" ]; then
    echo "\033[33mThe .ddev directory already exists. Skipping DDEV setup...\033[0m";
    exit 0;
fi

echo "Setting up DDEV...";

# Get project name
read -rp "Enter project name: " PROJECT_NAME;

# Copy .boilerplate/ddev to .ddev
echo "Copying $DIR/ddev to $DDEV_PATH";
cp -r $DIR/ddev $DDEV_PATH;

# Rename sample.config.m1.yaml to config.m1.yaml if Apple Silicon
if [ "$(uname -m)" = "arm64" ]; then
    mv $DDEV_PATH/sample.config.m1.yaml $DDEV_PATH/config.m1.yaml
fi

# Make sure to run the DDEV commands in the project directory
cd $BASE_PATH

if error_msg=$(ddev config --project-name="$PROJECT_NAME" --project-type=craftcms --auto 2>&1 >/dev/null); then
    make_output "    \033[32mProject $PROJECT_NAME created!\033[0m\n";
    make_output "    To remove and unlist this project, run this command:\n";
    make_output "    ddev stop --unlist $PROJECT_NAME && rm -rf .ddev";
else
    echo "\033[31mCan't create the project due to the following error:\033[0m\n";
    echo "$error_msg";
    echo "\033[31mCleaning up and exiting...";
    rm -rf .ddev;
    exit 1;
fi


print_output


