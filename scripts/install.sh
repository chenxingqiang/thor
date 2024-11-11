#!/usr/bin/env bash

set -e

# 检查系统要求
check_requirements() {
    local missing_deps=()

    # 检查必需的命令
    for cmd in git bash jq tree; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo "Error: Missing required dependencies: ${missing_deps[*]}"

        # 提供安装建议
        case "$(uname -s)" in
        Darwin*)
            echo "Install using Homebrew:"
            echo "  brew install ${missing_deps[*]}"
            ;;
        Linux*)
            if command -v apt-get >/dev/null 2>&1; then
                echo "Install using apt:"
                echo "  sudo apt-get install ${missing_deps[*]}"
            elif command -v yum >/dev/null 2>&1; then
                echo "Install using yum:"
                echo "  sudo yum install ${missing_deps[*]}"
            fi
            ;;
        esac
        exit 1
    fi
}

# 设置配置文件
setup_config() {
    local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/thor"
    mkdir -p "$config_dir"

    # 如果配置文件不存在，创建默认配置
    if [ ! -f "$config_dir/config" ]; then
        cat >"$config_dir/config" <<EOF
# Thor configuration file

# Editor preferences
PREFERRED_EDITOR="auto"  # auto, code, cursor, vim
FALLBACK_EDITOR="vim"

# Template settings
DEFAULT_TEMPLATE="react"
CUSTOM_TEMPLATES_DIR="\$HOME/.local/share/thor/templates"

# Git settings
DEFAULT_GITIGNORE_TEMPLATE="node"
GIT_AUTO_INIT=true

# Formatting
AUTO_FORMAT=true
PRETTIER_CONFIG="\$HOME/.config/thor/prettier.config.js"
EOF
    fi
}

# 设置shell补全
setup_completions() {
    # Bash
    if [ -d "$HOME/.bash_completion.d" ]; then
        cp completions/thor.bash "$HOME/.bash_completion.d/"
    fi

    # Zsh
    if [ -d "$HOME/.zsh/completions" ]; then
        cp completions/thor.zsh "$HOME/.zsh/completions/_thor"
    fi

    # Fish
    if [ -d "$HOME/.config/fish/completions" ]; then
        cp completions/thor.fish "$HOME/.config/fish/completions/"
    fi
}

# 主安装流程
main() {
    echo "Installing Thor..."

    # 检查要求
    check_requirements

    # 创建必要的目录
    make_prefix="${PREFIX:-/usr/local}"
    sudo mkdir -p "$make_prefix/"{bin,share/thor,share/man/man1}

    # 构建并安装
    make install PREFIX="$make_prefix"

    # 设置配置文件
    setup_config

    # 设置补全
    setup_completions

    # 验证安装
    if command -v thor >/dev/null 2>&1; then
        echo "✅ Thor installed successfully!"
        echo "Run 'thor --help' to get started"
    else
        echo "❌ Installation failed"
        exit 1
    fi
}

main "$@"
