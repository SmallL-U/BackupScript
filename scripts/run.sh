#!/usr/bin/env bash

if [ "$interrupt_enable" == "true" ]; then
  info "Docker interrupt is starting..."
  # Stop all containers with the specified keywords
  docker ps -a --format "{{.Names}}" | grep "$(printf -- "-e %s " "${interrupt_keywords[@]}")" | xargs docker stop
  info "Docker interrupt is started"
else
  info "Docker interrupt is disabled"
fi