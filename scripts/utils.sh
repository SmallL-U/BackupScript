#!/usr/bin/env bash

# Utils for reading values from config file
# Helper function to read a value for a given key from the config file, ignoring comment lines
read_config_value() {
    key=$1
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config file does not exist" >&2
        return 1
    fi

    # Attempt to read the value associated with the key, ignoring lines starting with #
    value=$(grep -v '^[[:space:]]*#' "$CONFIG_FILE" | grep "^${key}=" | cut -d'=' -f2-)

    if [ -z "$value" ]; then
        echo "Key not found in config file" >&2
        return 1
    fi

    echo "$value"
}

# Function to read an array of strings from the config file, where each element starts with a specific key
# The array elements are populated with values associated with the found keys
# Arguments:
#   arr - the name of the array variable to populate
#   key - the prefix of keys to search for in the config file
read_string_arr() {
    declare -n arr=$1  # Declare a name ref variable to indirectly reference the array provided by the caller
    key=$2
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config file does not exist" >&2
        return 1
    fi
    # Read the keys matching the prefix from the config file, ignoring comment lines
    mapfile -t keys < <(grep -v '^[[:space:]]*#' "$CONFIG_FILE" | grep "^$key" | cut -d'=' -f1)
    # Populate the array with values associated with the found keys
    for k in "${keys[@]}"; do
      mapfile -t -O "${#arr[@]}" arr < <(read_config_value "$k")
    done
    # Empty check
    if [ ${#arr[@]} -eq 0 ]; then
      echo "No keys found in config file" >&2
      return 1
    fi
}

# Function to read a string value for a given key from the config file
# Arguments:
#   key - the key to search for in the config file
read_string() {
    key=$1
    value=$(read_config_value "$key") || exit 1
    echo "$value"
}

# Function to read an integer value for a given key from the config file
# Validates that the fetched value is indeed an integer
# Arguments:
#   key - the key to search for in the config file
read_integer() {
    key=$1
    value=$(read_config_value "$key") || exit 1
    if ! [[ "$value" =~ ^-?[0-9]+$ ]]; then
        echo "Value for $key is not an integer" >&2
        exit 1
    fi
    echo "$value"
}

# Function to read a boolean value (true or false) for a given key from the config file
# Validates that the fetched value is either "true" or "false"
# Arguments:
#   key - the key to search for in the config file
read_boolean() {
    key=$1
    value=$(read_config_value "$key") || exit 1
    if ! [[ "$value" == "true" || "$value" == "false" ]]; then
        echo "Value for $key is not a boolean (true or false)" >&2
        exit 1
    fi
    echo "$value"
}

# Utils for logging

# Function to log an informational message to the console
# Arguments:
#   $* - the message to log
info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')]: $*"
}

# Function to log a warning message to the console with yellow color
# Arguments:
#   $* - the message to log
warn() {
    echo -e "\033[1;33m[$(date +'%Y-%m-%d %H:%M:%S')]: $*\033[0m"
}

# Function to log an error message to the console with red color, and outputs to stderr
# Arguments:
#   $* - the message to log
error() {
    echo -e "\033[0;31m[$(date +'%Y-%m-%d %H:%M:%S')]: $*\033[0m" >&2
}
