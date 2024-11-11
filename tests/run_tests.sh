#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Ensure thor is available
ensure_thor() {
    if ! command -v thor >/dev/null 2>&1; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    if ! command -v thor >/dev/null 2>&1; then
        echo -e "${RED}Error: thor command not found${NC}"
        echo "Please ensure thor is installed and in PATH"
        return 1
    fi
}

# Test environment setup
setup_test_env() {
    echo "🔧 Setting up test environment..."
    ensure_thor

    # Create temp directories
    TEST_DIR=$(mktemp -d)
    export THOR_TEST_DIR="$TEST_DIR"
    export THOR_CONFIG_HOME="${TEST_DIR}/config"
    export THOR_CACHE_DIR="${TEST_DIR}/cache"
    export THOR_TEMPLATE_DIR="${TEST_DIR}/templates"

    mkdir -p "$THOR_CONFIG_HOME" "$THOR_CACHE_DIR" "$THOR_TEMPLATE_DIR"
}

# Test environment cleanup
cleanup_test_env() {
    echo "🧹 Cleaning up test environment..."
    rm -rf "$THOR_TEST_DIR"
}

# Run tests
run_tests() {
    echo "Running tests..."
    echo

    # Run tests...
    # ... rest of run_tests.sh remains unchanged ...
}

# Main function
main() {
    echo "Running Thor test suite..."
    echo

    # Ensure thor is available
    ensure_thor || exit 1

    # Run tests
    run_tests
}

main "$@"
