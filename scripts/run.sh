#!/usr/bin/env bash

# Docker interrupt
if [ "$interrupt_enable" == "true" ]; then
  info "Docker interrupt is starting..."
  # Stop all containers with the specified keywords
  docker ps -a --format "{{.Names}}" | grep "$(printf -- "-e %s " "${interrupt_keywords[@]}")" | xargs docker stop
  info "Docker interrupt is started"
else
  info "Docker interrupt is disabled, canceled start interrupt"
fi

# Archive local sources
for key in "${!local_sources[@]}"; do
  info "Archiving local source: $key"
  tar -I pigz -cPf "${tmp_dir}/${key}-${current_date}.tar.gz" -C "$(dirname "${local_sources[$key]}")" "$(basename "${local_sources[$key]}")" || { error "Failed to archive tmp local source: $key"; continue; }
  info "Local source: $key is archived"
done

# Download remote sources and archive
for key in "${!remote_sources[@]}"; do
  info "Downloading remote source: $key"
  mkdir -p "${tmp_dir}/${key}"
  rclone copy "${remote_sources[$key]}" "${tmp_dir}/${key}" || { error "Failed to download tmp remote source: $key"; continue; }
  info "Archiving remote source: $key"
  tar -I pigz -cPf "${tmp_dir}/${key}-${current_date}.tar.gz" -C "${tmp_dir}" "${key}" || { error "Failed to archive tmp remote source: $key"; continue; }
  info "Removing remote source: $key"
  rm -rf "${tmp_dir}/${key}" || { error "Failed to remove tmp remote source: $key"; continue;}
  info "Remote source: $key is downloaded and archived"
done