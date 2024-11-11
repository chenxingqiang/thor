#!/usr/bin/env bash

set -e

# 定义版本号和其他构建变量
VERSION="0.1.0"
BUILD_DIR="build"
DIST_DIR="dist"

# 清理旧的构建文件
cleanup() {
    rm -rf "$BUILD_DIR" "$DIST_DIR"
    mkdir -p "$BUILD_DIR" "$DIST_DIR"
}

# 编译手册页
build_man_pages() {
    echo "Building man pages..."
    mkdir -p "$BUILD_DIR/man/man1"

    # 使用 ronn 将 markdown 转换为 man 页面
    if command -v ronn >/dev/null 2>&1; then
        ronn --roff docs/man/thor.1.ronn >"$BUILD_DIR/man/man1/thor.1"
    else
        echo "Warning: ronn not found, skipping man page generation"
        cp docs/man/thor.1 "$BUILD_DIR/man/man1/thor.1"
    fi
}

# 构建补全脚本
build_completions() {
    echo "Building shell completions..."
    mkdir -p "$BUILD_DIR/completions"

    # Bash
    thor --generate-completion bash >"$BUILD_DIR/completions/thor.bash"

    # Zsh
    thor --generate-completion zsh >"$BUILD_DIR/completions/thor.zsh"

    # Fish
    thor --generate-completion fish >"$BUILD_DIR/completions/thor.fish"
}

# 打包所有文件
create_package() {
    echo "Creating package..."

    # 复制主程序文件
    cp -r bin lib "$BUILD_DIR/"

    # 复制配置文件
    mkdir -p "$BUILD_DIR/config"
    cp config/thor.conf "$BUILD_DIR/config/"

    # 复制文档
    cp -r docs "$BUILD_DIR/"
    cp README.md LICENSE "$BUILD_DIR/"

    # 创建发布包
    PACKAGE="thor-${VERSION}"

    cd "$BUILD_DIR"
    tar czf "../$DIST_DIR/$PACKAGE.tar.gz" .
    cd -

    echo "Package created at $DIST_DIR/$PACKAGE.tar.gz"
}

# 运行测试
run_tests() {
    echo "Running tests..."
    if [ -d "tests" ]; then
        bash tests/run_tests.sh
    fi
}
# 主构建流程
main() {
    echo "Building Thor v$VERSION..."

    cleanup
    build_man_pages
    build_completions
    run_tests
    create_package

    echo "Build completed successfully!"
}

main "$@"
