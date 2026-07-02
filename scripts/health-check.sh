#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/infra"

echo "== Dynatrace lab health check =="

if [[ ! -f .env ]]; then
  echo "WARN: infra/.env no existe. Copia .env.example y rellena tokens."
else
  # shellcheck disable=SC1091
  source .env
  if [[ -z "${DYNATRACE_ENVIRONMENT_URL:-}" ]]; then
    echo "WARN: DYNATRACE_ENVIRONMENT_URL vacío en .env"
  else
    echo "OK: tenant configurado (${DYNATRACE_ENVIRONMENT_URL})"
  fi
fi

docker compose ps

echo ""
echo "HTTP checks:"
curl -sf "http://127.0.0.1:8080/" >/dev/null && echo "  demo-web :8080 OK" || echo "  demo-web :8080 FAIL"
curl -sf "http://127.0.0.1:8081/health" >/dev/null && echo "  demo-api :8081 OK" || echo "  demo-api :8081 FAIL"

echo ""
echo "Listo."
