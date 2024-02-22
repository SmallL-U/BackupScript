#!/usr/bin/env bash

# Docker interrupt
if [ "$interrupt_enable" == "true" ]; then
  info "Docker interrupt is stopping..."
  # Stop all containers with the specified keywords
  info docker ps -a --format "{{.Names}}" | grep "$(printf -- "-e %s " "${interrupt_keywords[@]}")" | xargs docker start
  info "Docker interrupt is stopped"
else
  info "Docker interrupt is disabled, canceled stop interrupt"
fi

# Copy tmp sources to local target
for key in "${!local_targets[@]}"; do
  info "Copying tmp source: $key to local target: ${local_targets[$key]}"
  info cp -r "${tmp_dir}" "${local_targets[$key]}" || { error "Failed to copy tmp source: $key"; continue; }
  info "Tmp source: $key is copied to local target: ${local_targets[$key]}"
done

# Upload tmp sources to remote target
for key in "${!remote_targets[@]}"; do
  info "Uploading tmp source: $key to remote target: ${remote_targets[$key]}"
  info ls "${tmp_dir}" | grep tar.gz | xargs -I {} rclone copy "${tmp_dir}/{}" "${remote_targets[$key]}" || { error "Failed to upload tmp source: $key"; continue; }
  info "Tmp source: $key is uploaded to remote target: ${remote_targets[$key]}"
done

# Cleanup tmp tar.gz
info "Cleaning up tmp tar.gz"
info rm "${tmp_dir}/*.tar.gz" || { error "Failed to cleanup tmp tar.gz"; }
info "Tmp tar.gz is cleaned up"

# Combine a target arr
target_arr=()
for key in "${!local_targets[@]}"; do
  target_arr+=("${local_targets[$key]}")
done
for key in "${!remote_targets[@]}"; do
  target_arr+=("${remote_targets[$key]}")
done
info "Combined target arr"

# Cleanup expired sources from target
for target in "${target_arr[@]}"; do
  info "Cleaning up expired sources from target: $target"
  rclone lsjson "${target}" | jq -r '.[] | select(.ModTime < "'"$cleanup_date"'") | .Path' | while read -r file; do
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
