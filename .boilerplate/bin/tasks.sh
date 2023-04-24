#!/bin/bash

CRAFT_PATH="cms"

ddev_setup() {
    local DDEV_PATH=".ddev"
    
    if ! command -v ddev &> /dev/null; then
        echo "\033[31mDDEV not found. Please install DDEV first.\033[0m";
        exit 1;
    fi
    
    if [ -d $DDEV_PATH ]; then
        echo "\033[33mThe .ddev directory already exists. Skipping DDEV setup...\033[0m";
    else
        echo "Setting up DDEV...";
        read -rp "Enter project name: " PROJECT_NAME;
        echo "Copying .boilerplate/ddev to .ddev";
        cp -r .boilerplate/ddev .ddev;
        
        if [ "$(uname -m)" = "arm64" ]; then
            mv .ddev/sample.config.m1.yaml .ddev/config.m1.yaml
        fi
        
        if error_msg=$(ddev config --project-name="$PROJECT_NAME" --project-type=craftcms --auto 2>&1 >/dev/null); then
            echo "\n*************************************************************\n";
            echo "    \033[32mProject $PROJECT_NAME created!\033[0m\n";
            echo "    To remove and unlist this project, run this command:\n";
            echo "    ddev stop --unlist $PROJECT_NAME && rm -rf .ddev";
            echo "\n*************************************************************\n";
        else
            echo "\033[31mCan't create the project due to the following error:\033[0m\n";
            echo "$error_msg";
            echo "\033[31mCleaning up and exiting...";
            rm -rf .ddev;
            exit 1;
        fi
    fi
}

ddev_up() {
    if [ ! "$(ddev describe | grep OK)" ]; then
        ddev start;
    else
        printf "\033[34mDDEV is already running.\033[0m";
    fi
}

cms_setup() {
    if [ -d "$CRAFT_PATH" ]; then
        echo "\033[33mThe cms directory already exists. Skipping CMS setup...\033[0m";
    else
        echo "Setting up CMS..."; \
        ddev_up;
        if [ ! -d "$CRAFT_PATH/vendor" ]; then
            echo "Installing Composer dependencies...";
            ddev composer create -y --no-scripts craftcms/craft;
        fi;
        echo "Copying .boilerplate/cms to cms";
        rsync -ur .boilerplate/cms/. cms/;
        echo "Copying cms/example.env to cms/.env";
        cp cms/example.env cms/.env;
        echo "Installing Craft...";
        ddev craft setup/app-id;
        ddev craft setup/security-key;
        ADMIN_PASSWORD=$(openssl rand -base64 8);
        ddev craft install/craft --interactive=0 --email="$(ADMIN_USERNAME)" --language="en-US" --password="$ADMIN_PASSWORD" --username="admin" --site-name="$(DEFAULT_SITE_NAME)";
        SITE_URL=$(ddev describe -j | jq -r '.raw.primary_url');
        if [ ! -f "$CRAFT_PATH/plugins.txt" ]; then
            echo "\033[31mCould not find plugins.txt file in $CRAFT_PATH.\033[0m";
        else
            echo "Add Craft plugins...";
            ddev composer config allow-plugins.treeware/plant false;
            ddev composer require --no-progress --no-scripts --no-interaction --optimize-autoloader --ignore-platform-reqs $(cat $CRAFT_PATH/plugins.txt);
            ddev craft plugin/install --all;
        fi; \
        echo "\n*************************************************************\n";
        echo "    \033[32mCraft CMS successfully set up!\033[0m\n";
        echo "    Site URL: $SITE_URL";
        echo "    Admin URL: $SITE_URL/admin";
        echo "    Username: $ADMIN_USERNAME";
        echo "    Password: $ADMIN_PASSWORD";
        echo "\n*************************************************************\n";
    fi
}

tester() {
    echo "tester";
}

