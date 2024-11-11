#!/usr/bin/env bash

# Source test framework
THOR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# shellcheck source=lib/test/framework.sh
source "${THOR_ROOT}/lib/test/framework.sh"

test_environment() {
    describe "Environment Setup" && {
        it "should have required commands installed" && {
            local missing=0
            for cmd in thor shellcheck git tree; do
                if ! command -v "$cmd" >/dev/null 2>&1; then
                    missing=1
                    break
                fi
            done
            return $missing
        }

        it "should have THOR_ROOT set" && {
            [[ -n "${THOR_ROOT}" ]]
        }

        it "should have thor in PATH" && {
            command -v thor >/dev/null 2>&1
        }
    }
}

test_config_dirs() {
    describe "Configuration Directories" && {
        it "should create config directory" && {
            mkdir -p "$THOR_CONFIG_HOME"
            assert_dir "$THOR_CONFIG_HOME"
        }

        it "should create cache directory" && {
            mkdir -p "$THOR_CACHE_DIR"
            assert_dir "$THOR_CACHE_DIR"
        }

        it "should create template directory" && {
            mkdir -p "$THOR_TEMPLATE_DIR"
            assert_dir "$THOR_TEMPLATE_DIR"
        }
    }
}

# Run tests if file is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    test_environment
    test_config_dirs
fi
