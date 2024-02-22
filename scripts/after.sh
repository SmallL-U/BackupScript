#!/usr/bin/env bash

# Docker interrupt
if [ "$interrupt_enable" == "true" ]; then
  info "Docker interrupt is stopping..."
  # Stop all containers with the specified keywords
  docker ps -a --format "{{.Names}}" | grep "$(printf -- "-e %s " "${interrupt_keywords[@]}")" | xargs docker start
  info "Docker interrupt is stopped"
else
  info "Docker interrupt is disabled, canceled stop interrupt"
fi

# Combine a target arr
target_arr=()
for key in "${!local_targets[@]}"; do
  target_arr+=("${local_targets[$key]}")
done
for key in "${!remote_targets[@]}"; do
  target_arr+=("${remote_targets[$key]}")
done
info "Combined target arr"

# Copy tmp source to target
for target in "${target_arr[@]}"; do
  info "Copying tmp source to target: $target"
  for file in "${tmp_dir}"/*.tar.gz; do
    if [[ -f "$file" ]]; then
      basename=$(basename "$file")
      info "Copying tmp source: $basename"
      if rclone copy "$file" "${target}"; then
        info "Tmp source: $basename is copied to target: $target"
      else
        error "Failed to copy tmp source: $basename"
        continue
      fi
    fi
  done
  info "Tmp source is copied to target: $target"
done

# Cleanup tmp tar.gz
info "Cleaning up tmp tar.gz"
rm "${tmp_dir}"/*.tar.gz || { error "Failed to cleanup tmp tar.gz"; }
info "Tmp tar.gz is cleaned up"

# Cleanup expired sources from target
for target in "${target_arr[@]}"; do
  info "Cleaning up expired sources from target: $target"
  rclone lsjson "${target}" | jq -r '.[] | select(.ModTime < "'"$cleanup_date"'") | .Path' | while read -r file; do
    # Skip empty line
    [ -z "$file" ] && continue
    info "Cleaning up expired source: $file"
    rclone delete "${target}/${file}" || { error "Failed to cleanup expired sources from target: $target"; continue; }
  done
  info "Expired sources are cleaned up from target: $target"
done

# Summary failed source
for file in "${tmp_dir}"/*; do
    # Skip if directory is empty
    [ -e "$file" ] || continue
    # Extract filename from path
    filename=$(basename "$file")
    # Continue loop if file ends with .tar.gz
    [[ $filename =~ \.tar\.gz$ ]] && continue
    # Your error handling or processing logic here
    error "Failed to process source: $filename"
done
