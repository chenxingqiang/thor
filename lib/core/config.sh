#!/usr/bin/env bash

# Configuration management
THOR_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/thor"
THOR_CONFIG_FILE="${THOR_CONFIG_HOME}/config"

# Set a configuration value
set_config() {
    local key="$1"
    local value="$2"

    # Create config directory if it doesn't exist
    mkdir -p "${THOR_CONFIG_HOME}"

    # Create config file if it doesn't exist
    touch "${THOR_CONFIG_FILE}"

    # Remove existing key if present
    sed -i.bak "/^${key}=/d" "${THOR_CONFIG_FILE}"
    rm -f "${THOR_CONFIG_FILE}.bak"

    # Add new key-value pair
    echo "${key}=${value}" >>"${THOR_CONFIG_FILE}"
}

# Get a configuration value
get_config() {
    local key="$1"

    # Return empty string if config file doesn't exist
    [[ ! -f "${THOR_CONFIG_FILE}" ]] && return 0

    # Get value for key
    grep "^${key}=" "${THOR_CONFIG_FILE}" | cut -d'=' -f2- || echo ""
}
