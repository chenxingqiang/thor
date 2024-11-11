#!/usr/bin/env bash

# Import shellspec
. shellspec

# Set up test environment
setup() {
    # Create temporary test directories
    TEST_DIR="$(mktemp -d)"
    TEST_CONFIG_DIR="${TEST_DIR}/config"
    TEST_DATA_DIR="${TEST_DIR}/data"
    TEST_CACHE_DIR="${TEST_DIR}/cache"

    mkdir -p "$TEST_CONFIG_DIR" "$TEST_DATA_DIR" "$TEST_CACHE_DIR"

    # Export test environment variables
    export XDG_CONFIG_HOME="$TEST_CONFIG_DIR"
    export XDG_DATA_HOME="$TEST_DATA_DIR"
    export XDG_CACHE_HOME="$TEST_CACHE_DIR"
}

# Clean up after tests
teardown() {
    rm -rf "$TEST_DIR"
}

# Helper to mock system commands
mock_command() {
    local cmd="$1"
    shift
    eval "${cmd}() { $*; }"
}

# Helper to assert file existence
assert_file_exists() {
    [ -f "$1" ] || fail "Expected file $1 to exist"
}

# Helper to assert directory existence
assert_dir_exists() {
    [ -d "$1" ] || fail "Expected directory $1 to exist"
}
