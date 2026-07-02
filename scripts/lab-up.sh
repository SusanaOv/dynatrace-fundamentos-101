#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/infra"

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Creado infra/.env desde .env.example — edítalo con tu tenant y tokens."
fi

docker compose up -d --build
"$ROOT/scripts/health-check.sh"
