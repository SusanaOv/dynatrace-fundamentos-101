#!/usr/bin/env bash
# Aplica la solución de referencia M04 (OpenTelemetry) — usar solo si te atascaste.
# El objetivo pedagógico es implementarlo tú en M04-01; esto es red de seguridad.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOL="$ROOT/labs/solutions/M04"

if [[ ! -d "$SOL" ]]; then
  echo "ERROR: No existe $SOL"
  exit 1
fi

echo "== Aplicando solución M04 (OpenTelemetry) =="
echo "Copia de referencia desde labs/solutions/M04/ → infra/demo-web/"
echo ""

cp "$SOL/api.py" "$ROOT/infra/demo-web/api.py"
cp "$SOL/requirements.txt" "$ROOT/infra/demo-web/requirements.txt"
cp "$SOL/Dockerfile.api" "$ROOT/infra/demo-web/Dockerfile.api"

echo "Reconstruyendo demo-api..."
docker compose -f "$ROOT/infra/docker-compose.yml" up -d --build --force-recreate demo-api

echo ""
echo "Validación local:"
"$ROOT/scripts/validate-lab.sh" m04 || true

echo ""
echo "Siguiente: en Dynatrace → Distributed Tracing → Spans → Service name = demo-api"
echo "Si no ves spans, espera 2–3 min y genera tráfico:"
echo "  for i in \$(seq 1 30); do curl -s http://127.0.0.1:8081/work >/dev/null; done"
