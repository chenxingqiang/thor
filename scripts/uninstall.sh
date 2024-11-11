#!/usr/bin/env bash

set -e

# Clean up configuration files
cleanup_config() {
    local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/thor"
    local data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/thor"
    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/thor"

    # Ask user if they want to delete configuration
    read -p "Remove configuration files? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$config_dir" "$data_dir" "$cache_dir"
        echo "✅ Configuration files removed"
    fi
}

# Clean up shell completions
cleanup_completions() {
    # Bash
    rm -f "$HOME/.bash_completion.d/thor.bash"

    # Zsh
    rm -f "$HOME/.zsh/completions/_thor"

    # Fish
    rm -f "$HOME/.config/fish/completions/thor.fish"
}

# Main uninstall process
main() {
    echo "Uninstalling Thor..."

    # Uninstall system files
    make_prefix="${PREFIX:-/usr/local}"
    sudo make uninstall PREFIX="$make_prefix"

    # Clean up configuration
    cleanup_config

    # Clean up completions
    cleanup_completions

    echo "✅ Thor uninstalled successfully"
}

main "$@"
