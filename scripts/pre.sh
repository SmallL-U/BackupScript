#!/usr/bin/env bash

# Check if backup is enabled
enable=$(read_boolean 'enable') || exit 1
if [ "$enable" == "false" ]; then
    error "Backup is disabled" >&2
fi

# Declare config variables
declare tmp_dir
declare cleanup_date
declare -A local_sources
declare -A remote_sources
declare -A local_targets
declare -A remote_targets
declare interrupt_enable
declare -A interrupt_keywords

cleanup_date=$(date -d "$(read_string "cleanup.date" || exit 1)" -Iminutes) || exit 1
tmp_dir=$(read_string "tmp_dir") || exit 1
read_string_map local_sources "source.local"
read_string_map remote_sources "source.remote"
read_string_map local_targets "target.local"
read_string_map remote_targets "target.remote"
interrupt_enable=$(read_boolean "interrupt.enable") || exit 1
read_string_map interrupt_keywords "interrupt.keyword"

# Declare runtime variables
declare current_date
current_date=$(date "+%Y%m%d%H%M%S")


# Print variables
info "Loaded tmp_dir: $tmp_dir"
info "Loaded cleanup_date: $cleanup_date"
for i in "${!local_sources[@]}"; do
    info "Loaded local_sources[$i]: ${local_sources[$i]}"
done
for i in "${!remote_sources[@]}"; do
    info "Loaded remote_sources[$i]: ${remote_sources[$i]}"
done
for i in "${!local_targets[@]}"; do
    info "Loaded local_targets[$i]: ${local_targets[$i]}"
done
for i in "${!remote_targets[@]}"; do
    info "Loaded remote_targets[$i]: ${remote_targets[$i]}"
done
info "Loaded interrupt_enable: $interrupt_enable"
for i in "${!interrupt_keywords[@]}"; do
    info "Loaded interrupt_keywords[$i]: ${interrupt_keywords[$i]}"
done
info "Generated current_date: $current_date"