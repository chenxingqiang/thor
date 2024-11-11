#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# Source test framework
THOR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/test/framework.sh
source "${THOR_ROOT}/lib/test/framework.sh"

# Ensure thor is in PATH
ensure_thor_in_path() {
    if ! command -v thor >/dev/null 2>&1; then
        export PATH="$HOME/.local/bin:$PATH"
        if ! command -v thor >/dev/null 2>&1; then
            echo -e "${RED}Error: thor not found in PATH${NC}"
            return 1
        fi
    fi
    return 0
}

# Main test function
main() {
    echo "🔧 Setting up test environment..."
    setup_test_env
    ensure_thor_in_path || exit 1

    echo "🧪 Running unit tests..."
    for test in tests/unit/test_*.sh; do
        echo "Running ${test}..."
        # shellcheck source=/dev/null
        source "$test"
    done

    print_test_results
    cleanup_test_env
}

main "$@"
