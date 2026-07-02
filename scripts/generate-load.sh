#!/usr/bin/env bash
# Genera carga y latencia para labs M04 (servicios / problems).
set -euo pipefail

BASE="${1:-http://127.0.0.1:8081}"
DURATION="${2:-120}"

echo "Generando carga sobre $BASE durante ${DURATION}s..."
end=$((SECONDS + DURATION))

while [[ $SECONDS -lt $end ]]; do
  curl -sf "$BASE/work" >/dev/null || true
  curl -sf "$BASE/slow" >/dev/null || true
  if (( RANDOM % 10 == 0 )); then
    curl -sf "$BASE/fail" >/dev/null || true
  fi
  sleep 1
done

echo "Listo. Revisa Services / Problems en Dynatrace."
