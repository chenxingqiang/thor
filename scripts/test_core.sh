#!/usr/bin/env bash

# Check environment
check_environment() {
    echo "Checking environment..."

    # Check required commands
    local missing_deps=()
    for cmd in shellspec git tree; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo "Missing required dependencies: ${missing_deps[*]}"
        exit 1
    fi
}

main() {
    check_environment

    # Run tests with ShellSpec
    shellspec --chdir "$(pwd)" spec/unit/core_spec.sh
}

main "$@"
