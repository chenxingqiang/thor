#!/usr/bin/env bash
# Editor detection and handling

# 检测可用的编辑器
detect_editor() {
    local preferred="${PREFERRED_EDITOR:-auto}"

    # 如果指定了特定编辑器
    if [ "$preferred" != "auto" ]; then
        if command -v "$preferred" >/dev/null 2>&1; then
            echo "$preferred"
            return 0
        fi
        echo "Warning: Preferred editor '$preferred' not found, falling back to auto detection" >&2
    fi

    # 自动检测
    if command -v cursor >/dev/null 2>&1; then
        echo "cursor"
        elif command -v code >/dev/null 2>&1; then
        echo "code"
        elif [ -n "$EDITOR" ]; then
        echo "$EDITOR"
        elif command -v vim >/dev/null 2>&1; then
        echo "vim"
    else
        echo "$FALLBACK_EDITOR"
    fi
}

# 打开文件或目录
open_in_editor() {
    local target="$1"
    local editor
    editor=$(detect_editor)

    case "$editor" in
        cursor)
            cursor "$target"
        ;;
        code)
            code "$target"
        ;;
        vim)
            vim "$target"
        ;;
        *)
            if command -v "$editor" >/dev/null 2>&1; then
                "$editor" "$target"
            else
                echo "No suitable editor found" >&2
                return 1
            fi
        ;;
    esac
}

# 检查编辑器是否支持特定功能
editor_supports_feature() {
    local editor="$1"
    local feature="$2"

    case "$feature" in
        "format")
            case "$editor" in
                code|cursor) return 0 ;;
                *) return 1 ;;
            esac
        ;;
        "remote")
            case "$editor" in
                code|cursor) return 0 ;;
                *) return 1 ;;
            esac
        ;;
        *)
            return 1
        ;;
    esac
}