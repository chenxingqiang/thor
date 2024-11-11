#!/usr/bin/env bash

# Configuration directory
CONFIG_DIR="${HOME}/.config/thor"

# Create config directory if it doesn't exist
mkdir -p "${CONFIG_DIR}"

# Set a configuration value
set_config() {
    local key="$1"
    local value="$2"
    local config_file="${CONFIG_DIR}/config"

    # Create config file if it doesn't exist
    touch "${config_file}"

    # Remove existing key if present
    sed -i "/^${key}=/d" "${config_file}"

    # Add new key-value pair
    echo "${key}=${value}" >>"${config_file}"
}

# Get a configuration value
get_config() {
    local key="$1"
    local config_file="${CONFIG_DIR}/config"

    # Return empty string if config file doesn't exist
    [[ ! -f "${config_file}" ]] && return 0

    # Get value for key
    local value
    value=$(grep "^${key}=" "${config_file}" | cut -d'=' -f2-)
    echo "${value}"
}
