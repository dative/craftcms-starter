#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  load 'test_helper/bats-file/load'
}

setup_file() {
  run sh .bin/ddev_setup.sh --project-name=$PROJNAME
  run ddev start
}

teardown_file() {
    if [ -d ".ddev" ]; then
      run ddev stop --unlist $PROJNAME && rm -rf .ddev
    fi
}

@test "Check if .ddev directory exists" {
  assert_exists .ddev
}

@test "Create buildchain with DDEV project setup " {
  run sh .bin/buildchain_setup.sh
  assert_exists node_modules
}