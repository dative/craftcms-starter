#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  load 'test_helper/bats-file/load'
}

setup_file() {
  run sh .bin/buildchain_setup.sh
}

@test "Check if .github/workflows/build-and-deploy.yml exists" {
  assert_exists .github/workflows/build-and-deploy.yml
}

@test "Check if src directory exists" {
  assert_exists src
}

@test "Check if .eslintignore exists" {
  assert_exists .eslintignore
}

@test "Check if .eslintrc exists" {
  assert_exists .eslintrc
}

@test "Check if .gitignore exists" {
  assert_exists .gitignore
}

@test "Check if .nvmrc exists" {
  assert_exists .nvmrc
}

@test "Check if .prettierrc exists" {
  assert_exists .prettierrc
}

@test "Check if d.ts exists" {
  assert_exists d.ts
}

@test "Check if package.json exists" {
  assert_exists package.json
}

@test "Check if postcss.config.cjs exists" {
  assert_exists postcss.config.cjs
}

@test "Check if README.md exists" {
  assert_exists README.md
}

@test "Check if tailwind.config.cjs exists" {
  assert_exists tailwind.config.cjs
}

@test "Check if tailwind.preset.cjs exists" {
  assert_exists tailwind.preset.cjs
}

@test "Check if tsconfig.json exists" {
  assert_exists tsconfig.json
}

@test "Check if vite.config.js exists" {
  assert_exists vite.config.js
}

@test "Check if vite.critical.config.js exists" {
  assert_exists vite.critical.config.js
}















