#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

copy_config_files() {
  mkdir "$DIR"/tmp
  cp "$DIR"/buildchain/template.* "$DIR"/tmp
  cd "$DIR"/tmp || exit
  for file in template.*; do mv "$file" "${file#template.}"; done
  cd "$PROJECT_ROOT" || exit
  rsync -ur "$DIR"/tmp/. "$PROJECT_ROOT"
  rm -rf "$DIR"/tmp
}

copy_src() {
  local INSTALL_SRC_PATH
  local FULL_INSTALL_SRC_PATH

  INSTALL_SRC_PATH=$(realpath -m --relative-base="$(pwd)" "$BASE_PATH/$SRC_PATH")
  FULL_INSTALL_SRC_PATH=$(realpath -m "$INSTALL_SRC_PATH")

  if [ -d "$FULL_INSTALL_SRC_PATH" ]; then
    raise "The $INSTALL_SRC_PATH directory already exists. Skipping...\n" "warning"
    return 0
  fi

  raise "Copying $DIR/buildchain/$SRC_PATH to $INSTALL_SRC_PATH\n"

  mkdir -p "$INSTALL_SRC_PATH"
  rsync -ur "$DIR/buildchain/$SRC_PATH/." "$INSTALL_SRC_PATH/"
}

copy_github() {
  local INSTALL_GITHUB_PATH
  local FULL_INSTALL_GITHUB_PATH

  INSTALL_GITHUB_PATH=$(realpath -m --relative-base="$(pwd)" "$BASE_PATH/$GITHUB_PATH")
  FULL_INSTALL_GITHUB_PATH=$(realpath -m "$INSTALL_GITHUB_PATH")

  if [ -d "$FULL_INSTALL_GITHUB_PATH" ]; then
    raise "The $INSTALL_GITHUB_PATH directory already exists. Skipping...\n" "warning"
    return 0
  fi

  raise "Copying $DIR/buildchain/$GITHUB_PATH to $INSTALL_GITHUB_PATH\n"

  mkdir -p "$INSTALL_GITHUB_PATH"
  rsync -ur "$DIR/buildchain/$GITHUB_PATH/." "$INSTALL_GITHUB_PATH/"
}

copy_root_files() {
  local INSTALL_ROOT_FILES_PATH
  local FULL_INSTALL_ROOT_FILES_PATH

  INSTALL_ROOT_FILES_PATH=$(realpath -m --relative-base="$(pwd)" "$BASE_PATH/$PROJECT_ROOT")
  FULL_INSTALL_ROOT_FILES_PATH=$(realpath -m "$INSTALL_ROOT_FILES_PATH")

  raise "Copying $DIR/buildchain/template.* to $INSTALL_ROOT_FILES_PATH\n"
  mkdir -p "$DIR/tmp"
  cp "$DIR/buildchain/template.*" "$DIR/tmp"
  cd "$DIR /tmp" || exit 1
  for file in template.*; do mv "$file" "${file#template.}"; done
  cd "$PROJECT_ROOT" || exit 1
  rsync -ur "$DIR/tmp/." "$FULL_INSTALL_ROOT_FILES_PATH/"
  rm -rf "$DIR"/tmp
}

setup_buildchain() {
  copy_src
  copy_github
  copy_root_files
  # copy_config_files

  # make_output "\033[32mBuildchain successfully set up!\033[0m\n"

  # if [ -d "$DDEV_PATH" ]; then
  #   ddev_up

  #   PROJECT_NAME=$(ddev describe -j | jq -r '.raw.name')

  #   # TODO: Update README.md, package.json, vite, etc. with project name
  #   # sed -i "s/###PROJECT_NAME###/$PROJECT_NAME/gi" $DIR/README.md

  #   # Install NPM dependencies
  #   ddev yarn

  #   make_output "To start development run this command:\n"
  #   make_output "ddev yarn start"

  # else
  #   make_output "DDEV project not configured. Skipping dependencies installation..."
  # fi

  # print_output

  # return 0

}

run_main() {
  check_required_environment "BASE_PATH SRC_PATH" || return 1
  check_required_ddev_command || return 1
  setup_buildchain "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_main "$*"
fi
