#!/usr/bin/env bash

# Unit test example

# shellcheck disable=SC2034
TESTS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

test_unit() {
    describe "Core Functions" && {
        it "should set and get config values" && {
            set_config "test.key" "value"
            assert_eq "$(get_config 'test.key')" "value"
        }
    }
}

# Run tests if file is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    test_unit
fi
