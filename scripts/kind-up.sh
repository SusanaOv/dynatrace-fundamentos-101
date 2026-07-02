#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$ROOT/infra/kind/cluster-config.yaml"
CLUSTER_NAME="dynatrace-lab"

if ! command -v kind >/dev/null 2>&1; then
  echo "ERROR: kind no instalado. En Codespaces: ver M05 o instalar kind."
  exit 1
fi

if kind get clusters 2>/dev/null | grep -qx "$CLUSTER_NAME"; then
  echo "Clúster $CLUSTER_NAME ya existe."
else
  kind create cluster --name "$CLUSTER_NAME" --config "$CONFIG"
fi

kubectl cluster-info --context "kind-${CLUSTER_NAME}"
echo "kind listo. Instala Dynatrace Operator en M05."
