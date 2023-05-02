#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

setup_craftcms() {
    
    if [ -d "$CRAFT_PATH" ]; then
        raise "\033[33mThe $CRAFT_PATH directory already exists. Skipping CMS setup...\033[0m";
        return 0;
    fi
    
    # TODO: let user know that he may need to enter sudo password
    
    echo "Setting up CMS...";
    
    # ddev_up;
    
    if [ ! -d "$CRAFT_PATH/vendor" ]; then
        echo "Installing Craft CMS using composer...";
        ddev composer create -y --no-scripts craftcms/craft;
    fi;
    
    # echo "Copying $DIR/cms to $CRAFT_PATH";
    rsync -ur $DIR/cms/. $CRAFT_PATH/;
    
    # echo "Copying $CRAFT_PATH/.env.example to $CRAFT_PATH/.env";
    cp $CRAFT_PATH/.env.example $CRAFT_PATH/.env;
    
    # echo "Installing Craft...";
    ddev craft setup/app-id
    ddev craft setup/security-key
    
    # Generate a random password
    ADMIN_PASSWORD=$(openssl rand -base64 8)
    
    SITE_URL=$(ddev describe -j | jq -r '.raw.primary_url')
    
    CRAFT_INSTALL_ARGS="--interactive=0 --email=${ADMIN_USERNAME} --language=en-US --password=${ADMIN_PASSWORD} --username=admin --site-name=\"${DEFAULT_SITE_NAME}\" --site-url=${SITE_URL}"
    
    ddev craft install/craft $CRAFT_INSTALL_ARGS
    
    # Replace PRIMARY_SITE_URL with $DDEV_PRIMARY_URL variable in .env file
    sed -i '' "s|PRIMARY_SITE_URL=.*|PRIMARY_SITE_URL=\"$\{DDEV_PRIMARY_URL\}\"|g" $CRAFT_PATH/.env
    
    if [ ! -f "$CRAFT_PATH/plugins.txt" ]; then
        echo "\033[31mCould not find plugins.txt file in $CRAFT_PATH.\033[0m"
    else
        PLUGINS_INSTALL_ARGS="--no-progress --no-scripts --no-interaction --optimize-autoloader --ignore-platform-reqs --update-with-dependencies $(cat $CRAFT_PATH/plugins.txt)"
        
        echo "Add Craft plugins..."
        ddev composer config allow-plugins.treeware/plant false
        ddev composer require $PLUGINS_INSTALL_ARGS
        ddev composer update
        # ddev craft plugin/install --all
    fi
    
    make_output "    \033[32mCraft CMS successfully set up!\033[0m\n";
    make_output "    Site URL: $SITE_URL";
    make_output "    Admin URL: $SITE_URL/admin";
    make_output "    Username: $ADMIN_USERNAME";
    make_output "    Password: $ADMIN_PASSWORD";
    
    print_output
}

run_main() {
    check_required_environment "CRAFT_PATH ADMIN_USERNAME PROJECT_ROOT" || exit 1
    check_required_ddev_command || exit 1
    setup_craftcms || exit 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    run_main
    if [ $? -gt 0 ]
    then
        exit 1
    fi
fi