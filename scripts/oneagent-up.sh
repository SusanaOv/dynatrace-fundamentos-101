#!/usr/bin/env bash
# Despliega OneAgent como contenedor Docker (full-stack) en el host del Codespace.
# Ref: https://docs.dynatrace.com/docs/ingest-from/setup-on-container-platforms/docker/set-up-dynatrace-oneagent-as-docker-container
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/infra/.env"
CONTAINER_NAME="dynatrace-oneagent"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: Falta $ENV_FILE — copia .env.example y rellena tokens."
  exit 1
fi

# shellcheck disable=SC1090
set -a
source "$ENV_FILE"
set +a

if [[ -z "${ONEAGENT_PAAS_TOKEN:-}" ]]; then
  echo "ERROR: ONEAGENT_PAAS_TOKEN vacío en infra/.env"
  exit 1
fi

if [[ -z "${ONEAGENT_INSTALLER_SCRIPT_URL:-}" ]]; then
  if [[ -z "${DYNATRACE_ENVIRONMENT_URL:-}" ]]; then
    echo "ERROR: Define ONEAGENT_INSTALLER_SCRIPT_URL o DYNATRACE_ENVIRONMENT_URL"
    exit 1
  fi
  base="${DYNATRACE_ENVIRONMENT_URL%/}"
  ONEAGENT_INSTALLER_SCRIPT_URL="${base}/api/v1/deployment/installer/agent/unix/default/latest?arch=x86&flavor=default"
fi

if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  if docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
    echo "OneAgent ya está en ejecución ($CONTAINER_NAME)."
    exit 0
  fi
  echo "Eliminando contenedor OneAgent previo detenido..."
  docker rm -f "$CONTAINER_NAME" >/dev/null
fi

echo "Desplegando OneAgent (puede tardar 1–3 min en la primera descarga)..."
docker volume create dynatrace_oneagent_storage >/dev/null 2>&1 || true

docker run -d \
  --name "$CONTAINER_NAME" \
  --restart=unless-stopped \
  --privileged \
  --pid=host \
  --network=host \
  -v /:/mnt/root \
  -v dynatrace_oneagent_storage:/mnt/volume_storage_mount \
  -e ONEAGENT_ENABLE_VOLUME_STORAGE=true \
  -e ONEAGENT_INSTALLER_SCRIPT_URL="$ONEAGENT_INSTALLER_SCRIPT_URL" \
  -e ONEAGENT_INSTALLER_DOWNLOAD_TOKEN="$ONEAGENT_PAAS_TOKEN" \
  dynatrace/oneagent

echo ""
echo "OneAgent arrancado. Comprueba logs:"
echo "  docker logs -f $CONTAINER_NAME"
echo ""
echo "En Dynatrace (2–5 min): Deployments → OneAgents → host del Codespace."
