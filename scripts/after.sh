#!/usr/bin/env bash

if [ "$interrupt_enable" == "true" ]; then
  info "Docker interrupt is stopping..."
  # Stop all containers with the specified keywords
  docker ps -a --format "{{.Names}}" | grep "$(printf -- "-e %s " "${interrupt_keywords[@]}")" | xargs docker start
  info "Docker interrupt is stopped"
else
  info "Docker interrupt is disabled"
fi