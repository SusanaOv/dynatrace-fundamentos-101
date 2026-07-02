#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="dynatrace-oneagent"

if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  docker rm -f "$CONTAINER_NAME"
  echo "OneAgent detenido y contenedor eliminado."
else
  echo "No hay contenedor $CONTAINER_NAME."
fi
