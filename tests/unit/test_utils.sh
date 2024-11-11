#!/usr/bin/env bash

source "${THOR_ROOT}/lib/test/framework.sh"

test_cleanup() {
    describe "Cleanup Functions" && {
        it "should cleanup test directories" && {
            local test_dir=$(mktemp -d)

            # Create test files
            mkdir -p "$test_dir/config"
            touch "$test_dir/config/test.txt"

            # Test cleanup
            rm -rf "$test_dir"
            assert_false "[[ -d $test_dir ]]"
        }
    }
}

test_path_utils() {
    describe "Path Utilities" && {
        it "should resolve relative paths" && {
            local base_dir="/test/path"
            local rel_path="../other"
            local resolved_path="$(cd "$base_dir" && cd "$rel_path" && pwd)"

            assert_eq "$resolved_path" "/test/other"
        }
    }
}
