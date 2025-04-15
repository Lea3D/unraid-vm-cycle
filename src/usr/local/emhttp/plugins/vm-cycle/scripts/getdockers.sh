#!/bin/bash
#

FILTER="$1"

case "$FILTER" in

  passthrough)
    for c in $(docker ps -a --format '{{.Names}}'); do
      TEMPLATE="/boot/config/plugins/dockerMan/templates-user/${c}.xml"
      [[ -f "$TEMPLATE" ]] && grep -q -Ei '(NVIDIA_VISIBLE_DEVICES|/dev/)' "$TEMPLATE" && echo "$c"
    done
    ;;
  all|*)
    docker ps -a --format '{{.Names}}'
    ;;
esac
