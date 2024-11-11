#!/usr/bin/env bash

source "${THOR_ROOT}/lib/test/framework.sh"

test_template_json() {
    describe "Template JSON files" && {
        it "should have valid React template.json" && {
            local template_file="${THOR_ROOT}/lib/templates/project/react/template.json"
            assert_file "$template_file"

            # Test JSON validity
            jq '.' "$template_file" >/dev/null 2>&1
            assert_true $?
        }

        it "should have required React template fields" && {
            local template_file="${THOR_ROOT}/lib/templates/project/react/template.json"
            assert_true "jq -e '.name' '$template_file' >/dev/null"
            assert_true "jq -e '.type' '$template_file' >/dev/null"
            assert_true "jq -e '.version' '$template_file' >/dev/null"
        }
    }
}

test_template_files() {
    describe "Template Source Files" && {
        it "should have valid Vue template" && {
            local template_file="${THOR_ROOT}/lib/templates/project/vue/template.txt"
            assert_file "$template_file"

            # Test Vue template syntax
            grep -q "<template>" "$template_file"
            assert_true $?
        }
    }
}
