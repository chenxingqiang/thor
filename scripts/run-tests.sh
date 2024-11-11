#!/usr/bin/env bash

# 设置严格模式
set -euo pipefail

# 确保在项目根目录运行
cd "$(dirname "$0")/.."

# 配置环境变量
export PATH="$PWD/bin:$PATH"
export THOR_ROOT="$PWD"
export THOR_TEST=true

# 创建临时测试目录
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

# 设置测试环境
export THOR_CONFIG_HOME="${TEST_DIR}/config"
export THOR_CACHE_DIR="${TEST_DIR}/cache"
export THOR_TEMPLATE_DIR="${TEST_DIR}/templates"

mkdir -p "$THOR_CONFIG_HOME" "$THOR_CACHE_DIR" "$THOR_TEMPLATE_DIR"

# 运行测试
echo "Running tests in ${TEST_DIR}..."

# 单元测试
echo "Running unit tests..."
for test in tests/unit/test_*.sh; do
    if [[ -f "$test" ]]; then
        echo "Running ${test}..."
        bash "$test"
    fi
done

# 集成测试
echo "Running integration tests..."
for test in tests/integration/test_*.sh; do
    if [[ -f "$test" ]]; then
        echo "Running ${test}..."
        bash "$test"
    fi
done

echo "All tests completed!"
