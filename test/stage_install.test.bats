#!/usr/bin/env bats
load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'
load 'test_helper/bats-file/load'

setup() {
  TMP_DIR="tmp"
  BASE_PATH="$DIR/$TMP_DIR"
  TMP_PATH="$(basename "$DIR")/$TMP_DIR"
  source 'stage_install.sh'
}

teardown() {
  rm -rf "$BASE_PATH"
}

@test "if create project in the default directory" {
  run run_main
  assert_output --partial "Local test setup completed!"
}

@test "if create project in the custom path" {
  run run_main --path="foo/bar"
  assert_output --partial "cd $TMP_PATH/foo/bar && make setup-project"
}

@test "if throws error if default directory exists" {
  run run_main
  run run_main
  assert_output --partial "A directory named \"$TMP_PATH/staged-project\" already exists!"
}
