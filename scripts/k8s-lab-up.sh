#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CTX="kind-dynatrace-lab"

kubectl config use-context "$CTX" 2>/dev/null || {
  echo "ERROR: clúster kind-dynatrace-lab no existe. Ejecuta ./scripts/kind-up.sh"
  exit 1
}

kubectl apply -f "$ROOT/infra/k8s/demo-workload.yaml"
kubectl -n dynatrace-lab rollout status deployment/lab-web --timeout=120s
kubectl -n dynatrace-lab get pods,svc

echo "Workloads de lab desplegados en namespace dynatrace-lab."
