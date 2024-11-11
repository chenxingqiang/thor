#!/usr/bin/env bash

# Test framework utilities
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test counters
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Additional assertions
assert_dir() {
    if [[ -d "$1" ]]; then
        return 0
    else
        echo "Directory $1 does not exist"
        return 1
    fi
}

assert_true() {
    if eval "$1"; then
        return 0
    else
        echo "Expected true, got false"
        return 1
    fi
}

assert_eq() {
    if [[ "$1" == "$2" ]]; then
        return 0
    else
        echo "Expected: $2"
        echo "Got: $1"
        return 1
    fi
}

# Test grouping functions
describe() {
    echo -e "\n${YELLOW}$1${NC}"
    if [[ -n "$2" ]]; then
        eval "$2"
    fi
}

it() {
    echo -n "  - $1: "
    if [[ -n "$2" ]]; then
        if eval "$2"; then
            echo -e "${GREEN}✓${NC}"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            echo -e "${RED}✗${NC}"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    fi
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
}

# Initialize test environment
setup_test_env() {
    TEST_DIR=$(mktemp -d)
    export THOR_TEST_DIR="$TEST_DIR"
    export THOR_CONFIG_HOME="${TEST_DIR}/config"
    export THOR_CACHE_DIR="${TEST_DIR}/cache"
    export THOR_TEMPLATE_DIR="${TEST_DIR}/templates"

    mkdir -p "$THOR_CONFIG_HOME" "$THOR_CACHE_DIR" "$THOR_TEMPLATE_DIR"
}

# Cleanup test environment
cleanup_test_env() {
    if [[ -n "$TEST_DIR" && -d "$TEST_DIR" ]]; then
        rm -rf "$TEST_DIR"
    fi
}

# Print test results
print_test_results() {
    echo -e "\nTest Results:"
    echo -e "Total: ${YELLOW}$TESTS_TOTAL${NC}"
    echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Failed: ${RED}$TESTS_FAILED${NC}"

    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "\n${GREEN}All tests passed!${NC}"
        return 0
    else
        echo -e "\n${RED}Some tests failed!${NC}"
        return 1
    fi
}
