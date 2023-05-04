#!/usr/bin/env bash

setup_suite() {
  set -eu -o pipefail
  # get the containing directory of this file
  # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
  # as those will point to the bats executable's location or the preprocessed file respectively
  export DIR
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"

  # make executables in src/ visible to PATH
  PATH="$DIR/../.bin:$PATH"
}

# teardown_suite() {
#   set -eu -o pipefail
#   cd "${TESTDIR}" || (echo "unable to cd to ${TESTDIR}" >&3 && exit 1)

#   ddev delete -Oy "${PROJNAME}" >/dev/null 2>&1
#   _delete_tmp
# }
