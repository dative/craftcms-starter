#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'
load 'test_helper/bats-file/load'

setup_file() {
  export TMP_DIR="tmp"
  export BASE_PATH="$DIR/$TMP_DIR"
  export TMP_PATH="$(basename "$DIR")/$TMP_DIR"
  export PROJNAME="test-project"
  source 'buildchain_setup.sh'
  run run_main
}

teardown_file() {
  rm -rf $BASE_PATH
}

@test "Check if .github/workflows/build-and-deploy.yml exists" {
  assert_exists $TMP_PATH/.github/workflows/build-and-deploy.yml
}

@test "Check if src directory exists" {
  assert_exists $TMP_PATH/src
}

@test "Check if .eslintignore exists" {
  assert_exists $TMP_PATH/.eslintignore
}

@test "Check if .eslintrc exists" {
  assert_exists $TMP_PATH/.eslintrc
}

@test "Check if .gitignore exists" {
  assert_exists $TMP_PATH/.gitignore
}

@test "Check if .nvmrc exists" {
  assert_exists $TMP_PATH/.nvmrc
}

@test "Check if .prettierrc exists" {
  assert_exists $TMP_PATH/.prettierrc
}

@test "Check if d.ts exists" {
  assert_exists $TMP_PATH/d.ts
}

@test "Check if package.json exists" {
  assert_exists $TMP_PATH/package.json
}

@test "Check if postcss.config.cjs exists" {
  assert_exists $TMP_PATH/postcss.config.cjs
}

@test "Check if README.md exists" {
  assert_exists $TMP_PATH/README.md
}

@test "Check if tailwind.config.cjs exists" {
  assert_exists $TMP_PATH/tailwind.config.cjs
}

@test "Check if tailwind.preset.cjs exists" {
  assert_exists $TMP_PATH/tailwind.preset.cjs
}

@test "Check if tsconfig.json exists" {
  assert_exists $TMP_PATH/tsconfig.json
}

@test "Check if vite.config.js exists" {
  assert_exists $TMP_PATH/vite.config.js
}

@test "Check if vite.critical.config.js exists" {
  assert_exists $TMP_PATH/vite.critical.config.js
}
