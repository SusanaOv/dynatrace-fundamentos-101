#!/usr/bin/env bash
# Instala Dynatrace Operator + DynaKube en kind (M05).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/infra/.env"
CTX="kind-dynatrace-lab"
OPERATOR_VERSION="${DYNATRACE_OPERATOR_VERSION:-v1.6.0}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: Falta $ENV_FILE"
  exit 1
fi

# shellcheck disable=SC1090
set -a
source "$ENV_FILE"
set +a

for var in DYNATRACE_ENVIRONMENT_URL DYNATRACE_API_TOKEN DYNATRACE_INGEST_TOKEN; do
  if [[ -z "${!var:-}" ]]; then
    echo "ERROR: $var vacío en infra/.env"
    exit 1
  fi
done

kubectl config use-context "$CTX"

echo "Instalando Dynatrace Operator ${OPERATOR_VERSION}..."
kubectl create namespace dynatrace --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f "https://github.com/Dynatrace/dynatrace-operator/releases/download/${OPERATOR_VERSION}/kubernetes.yaml"

echo "Esperando operator..."
kubectl -n dynatrace rollout status deployment/dynatrace-operator --timeout=180s

echo "Aplicando DynaKube..."
export DYNATRACE_ENVIRONMENT_URL="${DYNATRACE_ENVIRONMENT_URL%/}"
envsubst < "$ROOT/infra/k8s/dynakube.yaml.tpl" | kubectl apply -f -

echo ""
echo "Operator instalado. Comprueba:"
echo "  kubectl -n dynatrace get dynakube"
echo "  kubectl -n dynatrace get pods"
