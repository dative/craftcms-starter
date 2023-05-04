#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

get_ddev_config_options() {

  local PROJECT_NAME
  local PROJECT_TYPE
  local ARGS

  ARGS="$*"
  PROJECT_NAME=$(get_arg_value "--project-name" "$ARGS")
  PROJECT_TYPE=$(get_arg_value "--project-type" "$ARGS")

  if [[ -z "$PROJECT_NAME" ]]; then
    read -rp "Enter project name: " PROJECT_NAME
  else
    ARGS=$(remove_from_args "--project-name" "$ARGS")
  fi

  if [[ -z "$PROJECT_TYPE" ]]; then
    PROJECT_TYPE="craftcms"
  else
    ARGS=$(remove_from_args "--project-type" "$ARGS")
  fi

  ARGS=$(remove_from_args "--auto" "$ARGS")

  echo "--project-name=""$PROJECT_NAME"" --project-type=$PROJECT_TYPE --auto $ARGS"
}

setup_ddev() {

  local INSTALL_DDEV_PATH
  local FULL_INSTALL_DDEV_PATH

  INSTALL_DDEV_PATH=$(realpath -m --relative-base="$(pwd)" "$BASE_PATH/$DDEV_PATH")
  FULL_INSTALL_DDEV_PATH=$(realpath -m "$INSTALL_DDEV_PATH")

  if [ -d "$FULL_INSTALL_DDEV_PATH" ]; then
    raise "The $INSTALL_DDEV_PATH directory already exists. Skipping DDEV setup...\n" "warning"
    return 0
  fi

  raise "Setting up DDEV...\n"

  DDEV_CONFIG_ARGS=$(get_ddev_config_options "$*") || exit 1

  # Copy .bin/ddev to .ddev
  raise "Copying $DIR/ddev to $DDEV_PATH\n"

  mkdir -p "$INSTALL_DDEV_PATH"
  rsync -ur "$DIR"/ddev/. "$INSTALL_DDEV_PATH"/

  # Rename sample.config.m1.yaml to config.m1.yaml if Apple Silicon
  if [ "$(uname -m)" = "arm64" ]; then
    cp "$INSTALL_DDEV_PATH"/sample.config.m1.yaml "$INSTALL_DDEV_PATH"/config.m1.yaml
  fi

  cd "$BASE_PATH" || return 1

  # shellcheck disable=SC2086
  if error_msg=$(ddev config $DDEV_CONFIG_ARGS 2>&1 >/dev/null); then
    PROJECT_NAME=$(get_arg_value "--project-name" "$DDEV_CONFIG_ARGS")
    add_to_summary "Project $PROJECT_NAME created!\n"
    add_to_summary "To start DDEV, run this command:\n"
    add_to_summary "ddev start\n\n"
    add_to_summary "To remove and unlist this project, run this command:\n"
    add_to_summary "ddev stop --unlist $PROJECT_NAME && rm -rf $INSTALL_DDEV_PATH"
    print_summary "success"
  else
    add_to_summary "Can't create the project due to the following error:\n"
    add_to_summary "$error_msg\n"
    add_to_summary "Cleaning up and exiting..."
    print_summary "danger"
    rm -rf "$FULL_INSTALL_DDEV_PATH"
    exit 1
  fi
}

run_main() {
  check_required_environment "BASE_PATH DDEV_PATH" || return 1
  check_required_ddev_command || return 1
  check_if_args_unique "$@" || return 1
  setup_ddev "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_main "$*"
fi
