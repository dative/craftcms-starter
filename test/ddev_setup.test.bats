#!/usr/bin/env bats
load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'
load 'test_helper/bats-file/load'

setup() {
  TMP_DIR="tmp"
  BASE_PATH="$DIR/$TMP_DIR"
  TMP_PATH="$(basename "$DIR")/$TMP_DIR"
  PROJNAME="test-project"
  source 'ddev_setup.sh'
}

teardown() {
  if [ -d "$BASE_PATH" ]; then
    ddev stop --unlist $PROJNAME && rm -rf "$BASE_PATH"
  fi
}

@test "Creates DDEV project with given project name" {
  run run_main --project-name=$PROJNAME
  assert_output --partial "Project $PROJNAME created!"
}

@test "Creates DDEV project with user input" {
  run run_main <<<$PROJNAME
  assert_output --partial "Project $PROJNAME created!"
}

@test "Creates DDEV project with custom params" {
  run run_main --project-name=$PROJNAME --project-type=php --php-version=8.0
  assert_output --partial "Project $PROJNAME created!"
  assert_file_exists $BASE_PATH/.ddev/config.yaml
  assert_file_contains $BASE_PATH/.ddev/config.yaml "type: php"
  assert_file_contains $BASE_PATH/.ddev/config.yaml "php_version: \"8.0\""
}

@test "Skip DDEV project creation if .ddev directory exists" {
  # mock .ddev directory
  run run_main --project-name=$PROJNAME
  run run_main --project-name=$PROJNAME
  assert_output --partial "The $TMP_PATH/.ddev directory already exists. Skipping DDEV setup..."
}
