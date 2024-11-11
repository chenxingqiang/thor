#!/usr/bin/env bash

source "$(dirname "$0")/../../tests/run_tests.sh"

# 测试完整工作流
test_project_workflow() {
    describe "Project Workflow"

    # 设置测试环境
    local test_dir=$(mktemp -d)
    cd "$test_dir" || exit 1

    it "should create a new React project" && {
        thor init react test-app
        assert_dir_exists "test-app"
        assert_file_exists "test-app/package.json"
        assert_file_exists "test-app/.gitignore"
    }

    it "should create a component" && {
        cd test-app || exit 1
        thor create src/components/Button.tsx -t react
        assert_file_exists "src/components/Button.tsx"
    }

    it "should setup git" && {
        thor git init
        assert_dir_exists ".git"

        thor git ignore node
        assert_file_exists ".gitignore"
        assert_file_contains ".gitignore" "node_modules"
    }

    it "should install dependencies" && {
        if command -v pnpm >/dev/null 2>&1; then
            pnpm install
            assert_dir_exists "node_modules"
        fi
    }

    # 清理
    cd "$OLDPWD" || exit 1
    rm -rf "$test_dir"
}

# 测试模板管理
test_template_workflow() {
    describe "Template Management"

    local test_dir=$(mktemp -d)
    cd "$test_dir" || exit 1

    it "should create custom template" && {
        thor template create custom-template -t component
        assert_dir_exists ".thor/templates/component/custom-template"
    }

    it "should install remote template" && {
        thor template install https://github.com/example/template
        assert_dir_exists ".thor/templates/project/template"
    }

    it "should list templates" && {
        local output=$(thor template list)
        assert_not_empty "$output"
    }

    # 清理
    cd "$OLDPWD" || exit 1
    rm -rf "$test_dir"
}
# 测试配置管理
test_config_workflow() {
    describe "Configuration Management"

    local test_config=$(mktemp)
    export THOR_CONFIG_FILE="$test_config"

    it "should save preferences" && {
        thor config set editor.preferred "code"
        assert_file_contains "$THOR_CONFIG_FILE" "editor.preferred=code"
    }

    it "should load preferences" && {
        local value=$(thor config get editor.preferred)
        assert_eq "$value" "code"
    }

    # 清理
    rm -f "$test_config"
}

main() {
    test_project_workflow
    test_template_workflow
    test_config_workflow
}

main "$@"
