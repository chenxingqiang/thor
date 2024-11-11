#!/usr/bin/env bash

set -euo pipefail

# Create temporary test home directory
export TEST_HOME=$(mktemp -d)
trap 'rm -rf "$TEST_HOME"' EXIT

# Set environment variables for testing
export XDG_CONFIG_HOME="$TEST_HOME/.config"
export XDG_DATA_HOME="$TEST_HOME/.local/share"
export XDG_CACHE_HOME="$TEST_HOME/.cache"
export HOME="$TEST_HOME"

# Create necessary test directories
mkdir -p \
    "$XDG_CONFIG_HOME/thor" \
    "$XDG_DATA_HOME/thor" \
    "$XDG_CACHE_HOME/thor" \
    "$HOME/.bash_completion.d" \
    "$HOME/.zsh/completions" \
    "$HOME/.config/fish/completions"

# Run ShellSpec
shellspec --format documentation
