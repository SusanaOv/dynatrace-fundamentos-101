#!/usr/bin/env bash
# Oculta email/tenant del dock inferior e icono de perfil en capturas Dynatrace.
# Uso: ./scripts/redact-capture.sh labs/img/M01-02-*.png
set -euo pipefail
FILL='#0f1117'
for f in "$@"; do
  [[ -f "$f" ]] || { echo "skip: $f"; continue; }
  convert "$f" \
    -fill "$FILL" -draw 'rectangle 0,868 78,971' \
    -fill "$FILL" -draw 'rectangle 0,0 78,120' \
    "$f"
  echo "OK: $f ($(file -b "$f"))"
done
