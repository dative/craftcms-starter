# Template Instructions

My intent is that the `setup` command can be broken into sub tasks that can handle different the parts of the project setup:

- DDEV:

  - Check if ddev is installed in the system
  - Check if `.ddev` existis in the project root, and if it doesn't:
    - Copy `.boilerplate/ddev` to .ddev
    - Prompt for the `project-name`
    - Run `ddev config --project-name=<project-name>` with the project name
    - Run `ddev start`

- CMS:

  - Check if `cms` directory exists in the project root, and if it doesn't:
    - Copy `.boilerplate/cms` to `cms`
    - Copy cms/example.env to cms/.env
  - Check if DDEV is running, and if it isn't:
    - Start DDEV
  - Check if Craft is already installed, and if it isn't:
    - Install composer dependencies using DDEV
    - Install Craft using DDEV
    - Install plugins using DDEV

- Frontend:

  - Check if `src` directory exists in the project root, and if it doesn't:
    - Copy `.boilerplate/src` to `src`
  - Check and copy each file in `.boilerplate/devtools` directory that doesn't exist to the project root
  - Check if DDEV is running, and if it isn't:
    - Start DDEV
  - Check if `node_modules` exist at the root of the project, and if it doesn't:
    - Install npm dependencies using DDEV

ddev craft install/craft --interactive=0 --email="$(ADMIN_USERNAME)" --language="en-US" --password="$(TMP_CRAFT_PASS)" --username="admin" --site-name="$(DEFAULT_SITE_NAME)"; \

# Windows Notes:

- Need to run in WSL2
- Need to install `make` with `sudo apt install make`
- Need to install `jq` with `sudo apt install jq`

# Forgot New Install Admin Password

ddev craft users/set-password info@hellodative.com --password=NEW_PASSWORD

# Reset cms-setup command

cat drop.sql | ddev mysql && ddev stop && rm -rf cms && make cms-setup

# Craft Config Files

- general.php
- vite.php

# Front End Config Files

- tsconfig.json
- package.json

# Notes on Alpine and CSP

https://alpinejs.dev/advanced/csp

# Imager-X

Make sure you are using the Pro version instead of the Lite version.
