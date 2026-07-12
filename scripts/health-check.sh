#!/usr/bin/env bash
# =============================================================================
# health-check.sh — Diagnóstico rápido del lab Docker + conectividad HTTP
# =============================================================================
#
# PROPÓSITO DEL LAB:
#   Script de "smoke test" que tú (o lab-up.sh) ejecuta para confirmar:
#     1) Que infra/.env existe y tiene el tenant Dynatrace configurado.
#     2) Que los contenedores Docker están UP.
#     3) Que las apps responden en localhost.
#
# USO:
#   ./scripts/health-check.sh
#
# NOTAS:
#   - ¿Por qué comprobamos el tenant aunque este script no llame a la API DT?
#     → Feedback temprano: si falta .env, OneAgent/Operator también fallarán.
#   - curl -sf: -s silencioso, -f falla en HTTP 4xx/5xx (no "éxito falso").
# =============================================================================

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/infra"

echo "== Dynatrace lab health check =="

# --- Comprobar configuración Dynatrace en .env -------------------------------
if [[ ! -f .env ]]; then
  # Sin .env el lab puede arrancar, pero no habrá ingest ni despliegue de agentes.
  echo "WARN: infra/.env no existe. Copia .env.example y rellena tokens."
else
  # Cargar variables del .env en el shell actual (DYNATRACE_ENVIRONMENT_URL, etc.).
  # shellcheck disable=SC1091  → SC1091 avisa de source de ruta relativa; aquí es OK.
  source .env

  # ${VAR:-} → Si VAR no existe, expande a cadena vacía (compatible con set -u).
  if [[ -z "${DYNATRACE_ENVIRONMENT_URL:-}" ]]; then
    echo "WARN: DYNATRACE_ENVIRONMENT_URL vacío en .env"
  else
    # Mostramos el tenant para que tú verifique que apunta al trial correcto.
    echo "OK: tenant configurado (${DYNATRACE_ENVIRONMENT_URL})"
  fi
fi

# --- Estado de contenedores según Docker Compose -----------------------------
# Lista nombre, estado (Up/Exit), puertos mapeados. Diagnóstico visual rápido.
docker compose ps

echo ""
echo "HTTP checks:"

# demo-api: endpoint /health — reintentos (demo-api tarda en arrancar tras compose up).
http_ok() {
  local url=$1 label=$2
  local i
  for i in 1 2 3 4 5 6 7 8 9 10; do
    if curl -sf "$url" >/dev/null 2>&1; then
      echo "  $label OK"
      return 0
    fi
    sleep 2
  done
  echo "  $label FAIL"
  return 1
}

http_ok "http://127.0.0.1:8080/" "demo-web :8080" || true
http_ok "http://127.0.0.1:8081/health" "demo-api :8081" || true

echo ""
echo "Listo."
