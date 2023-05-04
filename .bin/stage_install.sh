#!/usr/bin/env bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

stage_test() {
  local INSTALL_PATH

  INSTALL_PATH=$(get_arg_value "--path" "$@")

  if [ -z "$INSTALL_PATH" ]; then
    INSTALL_PATH="$STAGED_NAME"
  fi

  INSTALL_PATH=$(realpath -m --relative-base="$(pwd)" "$BASE_PATH/$INSTALL_PATH")
  FULL_INSTALL_PATH=$(realpath -m "$INSTALL_PATH")

  # check if INSTALL_PATH exists, if not create it
  if [ -d "$FULL_INSTALL_PATH" ]; then
    raise "A directory named \"$INSTALL_PATH\" already exists!\n" "danger"
    return 1
  fi

  mkdir -p "$FULL_INSTALL_PATH"

  # # Copy the Makefile and the .bin directory to FULL_INSTALL_PATH
  cp Makefile "$FULL_INSTALL_PATH"
  cp -r .bin "$FULL_INSTALL_PATH"
  add_to_summary "Local test setup completed!\n"
  add_to_summary "To run the install, run the following:\n"
  add_to_summary "cd $INSTALL_PATH && make setup-project"

  print_summary "success"
}

run_main() {
  check_if_args_unique "$@" || return 1
  stage_test "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_main "$*"
fi
