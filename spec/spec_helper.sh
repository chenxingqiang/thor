# Set the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load common test utilities
. "${PROJECT_ROOT}/tests/unit/test_helper.sh"

# Global setup function
setup_test_env() {
    TEST_DIR="$(mktemp -d)"
    export TEST_DIR
    export THOR_TEST=true
    export THOR_HOME="${TEST_DIR}"
    export THOR_CONFIG_HOME="${TEST_DIR}/.config/thor"
    export THOR_DATA_HOME="${TEST_DIR}/.local/share/thor"
    export THOR_CACHE_HOME="${TEST_DIR}/.cache/thor"

    mkdir -p \
        "${THOR_CONFIG_HOME}" \
        "${THOR_DATA_HOME}" \
        "${THOR_CACHE_HOME}"
}

# Global cleanup function
cleanup_test_env() {
    if [ -d "${TEST_DIR}" ]; then
        rm -rf "${TEST_DIR}"
    fi
}
