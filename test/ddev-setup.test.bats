#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  load 'test_helper/bats-file/load'
}

teardown() {
    if [ -d ".ddev" ]; then
      run ddev stop --unlist $PROJNAME && rm -rf .ddev
    fi
}

@test "Creates DDEV project with user input" {
  run sh .bin/ddev_setup.sh <<< $PROJNAME
  assert_output --partial "Project $PROJNAME created!"
}

@test "Creates DDEV project with --project-name=$PROJNAME" {
  run sh .bin/ddev_setup.sh --project-name=$PROJNAME

  assert_output --partial "Project $PROJNAME created!"
}

@test "Creates DDEV project with custom params" {
  run sh .bin/ddev_setup.sh --project-name=$PROJNAME --project-type=php --php-version=8.0

  assert_output --partial "Project $PROJNAME created!"
  assert_file_exists .ddev/config.yaml
  assert_file_contains .ddev/config.yaml "type: php"
  assert_file_contains .ddev/config.yaml "php_version: \"8.0\""
}

@test "Skip DDEV project creation if .ddev directory exists" {
  # mock .ddev directory
  mkdir .ddev

  run sh .bin/ddev_setup.sh
  assert_output --partial "The .ddev directory already exists. Skipping DDEV setup..."
}