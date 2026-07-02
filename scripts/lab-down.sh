#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/infra"

docker compose down -v
echo "Stack Docker del lab detenido."
