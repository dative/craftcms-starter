#!/bin/bash

# Load common functions and variables
DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/common.sh"

run_main() {
  TPATH=./bar
  INSTALL_PATH=$(realpath -m --relative-base="$(pwd)" "$BASE_PATH/$TPATH")
  OUTP="$(basename "$INSTALL_PATH")"
  echo "$OUTP"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_main
  if [ $? -gt 0 ]; then
    exit 1
  fi
fi
