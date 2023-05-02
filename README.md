# craftcms-starter

## Overview

`craftcms-starter` is a project starter tool designed to streamline the setup process for a Craft CMS project with a modern development environment. This tool integrates a Makefile, Docker, DDEV, Craft CMS, ViteJS, and Tailwind CSS to provide a seamless setup experience for your team.

The git repository for the tool can be found at [https://github.com/dative/craftcms-starter](https://github.com/dative/craftcms-starter).

## Notable Features

- [DDEV](https://ddev.readthedocs.io/) for local development
- [Craft CMS 4.x](https://craftcms.com/) for content management
- [Vite 4.x](https://vitejs.dev/) for front-end bundling & HMR
- [Tailwind 3.x](https://tailwindcss.com) for utility-first CSS
- [Alpine 3.x](https://alpinejs.dev/) for lightweight reactivity
- [Makefile](https://www.gnu.org/software/make/manual/make.html) for common CLI commands

## Prerequisites

Before using the `craftcms-starter` tool, make sure you have the following installed:

- [Docker](https://docs.docker.com/get-docker/)
- [DDEV](https://ddev.readthedocs.io/), minimum version v1.21.6

## Getting Started

## Commands

To set up a new project, run the following command in your terminal:

```sh
make setup-project
```

This command executes three individual tasks sequentially: `ddev-setup`, `buildchain-setup`, and `cms-setup`. You can also run these tasks individually if needed.

### ddev-setup

This task sets up the DDEV environment for the project. To run this task individually, use:

```sh
make ddev-setup
```

### buildchain-setup

This task sets up the build chain, which includes ViteJS and Tailwind CSS. To run this task individually, use:

```sh
make buildchain-setup
```

### cms-setup

This task sets up the Craft CMS environment, including the necessary configuration files and templates. To run this task individually, use:

```sh
make cms-setup
```

## Template System

The `craftcms-starter` comes with an opinionated base template system that is designed to get you up and running quickly. You can use the templates as-is, or you can customize them to your project needs.

To learn more about the template system, see the [Template System](TEMPLATES.md) section below.

## Customization

You can customize the setup process by modifying the `Makefile` variables. Uncomment and set the following variables to override the default values:

- `CRAFT_PATH`: The path where the Craft CMS files will be located.
- `DDEV_PATH`: The path where the DDEV files will be located.
- `SRC_PATH`: The path where the source files (CSS, JS, and others) will be located.
- `DEFAULT_SITE_NAME`: The default name for the site.
- `ADMIN_USERNAME`: The default admin username.

For example, to change the default Craft CMS path to `my-cms`, you can update the `Makefile` as follows:

```make
CRAFT_PATH := my-cms
```

After updating the variables, run the setup-project command to apply the changes.

## Roadmap

- Add support for Windows WSL
