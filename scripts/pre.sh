#!/usr/bin/env bash

# Check if backup is enabled
enable=$(read_boolean 'enable') || exit 1
if [ "$enable" == "false" ]; then
    error "Backup is disabled" >&2
    exit 1
fi

# Declare variables
declare tmp_dir
declare -a sources
declare -a targets
declare interrupt_enable
declare interrupt_keywords

tmp_dir=$(read_string "tmp_dir") || exit 1
read_string_arr sources "source"
read_string_arr targets "target"
interrupt_enable=$(read_boolean "interrupt.enable") || exit 1
read_string_arr interrupt_keywords "interrupt.keyword"

# Print variables
info "Loaded tmp_dir: $tmp_dir"
for i in "${!sources[@]}"; do
    info "Loaded source[$i]: ${sources[$i]}"
done
for i in "${!targets[@]}"; do
    info "Loaded target[$i]: ${targets[$i]}"
done
info "Loaded interrupt_enable: $interrupt_enable"
for i in "${!interrupt_keywords[@]}"; do
    info "Loaded interrupt_keywords[$i]: ${interrupt_keywords[$i]}"
done