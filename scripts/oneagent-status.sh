#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="dynatrace-oneagent"

echo "== OneAgent status =="
if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  docker ps -a --filter "name=$CONTAINER_NAME"
  echo ""
  echo "Últimas líneas del log:"
  docker logs --tail 20 "$CONTAINER_NAME" 2>&1 || true
else
  echo "OneAgent no desplegado. Ejecuta: ./scripts/oneagent-up.sh"
fi
