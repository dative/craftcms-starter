# -- GLOBAL Variables --

DDEV_PATH=${DDEV_PATH:-".ddev"}
CRAFT_PATH=${CRAFT_PATH:-"cms"}
SRC_PATH=${SRC_PATH:-"src"}
DEFAULT_SITE_NAME=${DEFAULT_SITE_NAME:-"Dative Boilerplate"}
ADMIN_USERNAME=${ADMIN_USERNAME:-"info@hellodative.com"}
PROJECT_ROOT=$PWD
SCRIPT_OUTPUT=${SCRIPT_OUTPUT:-}

# -- Functions --

check_ddev_command() {
    if ! command -v ddev >/dev/null 2>&1; then
        echo "\033[31mDDEV not found. Please install DDEV first.\033[0m";
        exit 1;
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
        echo "\n*************************************************************\n";
        echo "$SCRIPT_OUTPUT";
        echo "\n*************************************************************\n";
    fi
}