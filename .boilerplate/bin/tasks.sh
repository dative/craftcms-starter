#!/bin/sh

DDEV_PATH=".ddev"
CRAFT_PATH="cms"
SRC_PATH="src"
DEFAULT_SITE_NAME="Dative Boilerplate"
ADMIN_USERNAME="info@hellodative.com"

ddev_setup() {
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
    exit 0;
}

cms_setup() {
    # TODO: let user know that he may need to enter sudo password
    if [ -d "$CRAFT_PATH" ]; then
        echo "\033[33mThe cms directory already exists. Skipping CMS setup...\033[0m";
    else
        echo "Setting up CMS...";
        ddev_up;
        if [ ! -d "$CRAFT_PATH/vendor" ]; then
            echo "Installing Composer dependencies...";
            ddev composer create -y --no-scripts craftcms/craft;
        fi;
        echo "Copying .boilerplate/cms to $CRAFT_PATH";
        rsync -ur .boilerplate/cms/. $CRAFT_PATH/;
        echo "Copying $CRAFT_PATH/example.env to $CRAFT_PATH/.env";
        cp $CRAFT_PATH/example.env $CRAFT_PATH/.env;
        echo "Installing Craft...";
        ddev craft setup/app-id;
        ddev craft setup/security-key;
        ADMIN_PASSWORD=$(openssl rand -base64 8);
        SITE_URL=$(ddev describe -j | jq -r '.raw.primary_url');
        ddev craft install/craft --interactive=0 --email="$ADMIN_USERNAME" --language="en-US" --password="$ADMIN_PASSWORD" --username="admin" --site-name="$DEFAULT_SITE_NAME" --site-url="$SITE_URL";
        # Replace PRIMARY_SITE_URL with $DDEV_PRIMARY_URL variable in .env file
        sed -i '' "s|PRIMARY_SITE_URL=.*|PRIMARY_SITE_URL=\"$\{DDEV_PRIMARY_URL\}\"|g" $CRAFT_PATH/.env;
        if [ ! -f "$CRAFT_PATH/plugins.txt" ]; then
            echo "\033[31mCould not find plugins.txt file in $CRAFT_PATH.\033[0m";
        else
            echo "Add Craft plugins...";
            ddev composer config allow-plugins.treeware/plant false;
            ddev composer require --no-progress --no-scripts --no-interaction --optimize-autoloader --ignore-platform-reqs --update-with-dependencies $(cat $CRAFT_PATH/plugins.txt);
            ddev craft plugin/install --all;
        fi; \
        echo "\n*************************************************************\n";
        echo "    \033[32mCraft CMS successfully set up!\033[0m\n";
        echo "    Site URL: $SITE_URL";
        echo "    Admin URL: $SITE_URL/admin";
        echo "    Username: $ADMIN_USERNAME";
        echo "    Password: $ADMIN_PASSWORD\n";
        echo "    To remove the CMS files and database, run this command:\n";
        echo "    make cms-teardown";
        echo "\n*************************************************************\n";
    fi
    exit 0;
}

# cms_teardown() {
#     # Prompt user to confirm that he wants to delete the CMS
#     read -rp "Are you sure you want to delete the CMS directory and DB? [y/N] " response;
#     if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
#         echo "Deleting CMS files and Database...";
#         cat ./.boilerplate/bin/drop.sql | ddev mysql && ddev stop && rm -rf cms;
#     else
#         echo "Aborting...";
#     fi
#     exit 0;
# }

buildchain_setup() {
    if [ -d "$SRC_PATH" ]; then
        echo "\033[33mThe src directory already exists. Skipping Buildchain setup...\033[0m";
    else
        echo "Setting up Buildchain...";
        # Make sure DDEV is running
        ddev_up;
        # Rsync the boilerplate/buildchain/src directory to SRC_PATH
        echo "Copying .boilerplate/buildchain/src to $SRC_PATH";
        rsync -ur .boilerplate/buildchain/src/. $SRC_PATH/;
        # Rsync the boilerplate/buildchain/template.* files to project root
        echo "Copying .boilerplate/buildchain/template.* to root";
        cp .boilerplate/buildchain/template.* .;
        # Remove the "template." prefix from the template.* files
        for file in template.*; do mv "$file" "${file#template.}";done;
        # Install NPM dependencies
        ddev yarn;
        echo "\n*************************************************************\n";
        echo "    \033[32mBuildchain successfully set up!\033[0m\n";
        echo "    To start development run this command:\n";
        echo "    ddev yarn start";
        echo "\n*************************************************************\n";
    fi
    exit 0;
}

tester() {
    echo "tester!";
    exit 0;
}

command_help() {
    echo "ADD COMMAND HELP HERE";
}

ddev_up() {
    if [ ! "$(ddev describe | grep OK)" ]; then
        ddev start;
    else
        printf "\033[34mDDEV is already running.\033[0m";
    fi
}

case "$1" in
    "") command_help;;
    help) command_help; exit;;
    ddev_setup) "$@"; exit;;
    cms_setup) "$@"; exit;;
    buildchain_setup) "$@"; exit;;
    command_help) "$@"; exit;;
    tester) "$@"; exit;;
    *) "$@"; exit 2;;
esac