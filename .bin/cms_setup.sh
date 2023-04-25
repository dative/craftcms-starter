#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

if [ -d "$CRAFT_PATH" ]; then
    echo "\033[33mThe cms directory already exists. Skipping CMS setup...\033[0m";
    exit 0;
fi

# TODO: let user know that he may need to enter sudo password

echo "Setting up CMS...";
ddev_up;
if [ ! -d "$CRAFT_PATH/vendor" ]; then
    echo "Installing Composer dependencies...";
    ddev composer create -y --no-scripts craftcms/craft;
fi;

echo "Copying $DIR/cms to $CRAFT_PATH";
rsync -ur $DIR/cms/. $CRAFT_PATH/;

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
fi

make_output "    \033[32mCraft CMS successfully set up!\033[0m\n";
make_output "    Site URL: $SITE_URL";
make_output "    Admin URL: $SITE_URL/admin";
make_output "    Username: $ADMIN_USERNAME";
make_output "    Password: $ADMIN_PASSWORD";

print_output