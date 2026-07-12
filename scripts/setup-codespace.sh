#!/usr/bin/env bash
# Bootstrap del Codespace: permisos, .env plantilla, herramientas M05.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

chmod +x scripts/*.sh 2>/dev/null || true

if [[ ! -f infra/.env ]]; then
  cp infra/.env.example infra/.env
fi

if ! command -v kind >/dev/null 2>&1; then
  echo "[setup-codespace] Instalando kind..."
  curl -fsSL -o /tmp/kind "https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64"
  chmod +x /tmp/kind
  sudo mv /tmp/kind /usr/local/bin/kind
fi

if ! command -v envsubst >/dev/null 2>&1; then
  echo "[setup-codespace] Instalando gettext-base (envsubst)..."
  sudo apt-get update -qq
  sudo apt-get install -y -qq gettext-base
fi

echo "[setup-codespace] Listo. Siguiente: labs/M01-entorno-codespace-plataforma/README.md"
