#!/usr/bin/env bash
# =============================================================================
# validate-lab.sh — Comprueba el entorno del alumno por checkpoint de módulo
# =============================================================================
#
# USO:
#   ./scripts/validate-lab.sh          # comprobaciones generales (M01)
#   ./scripts/validate-lab.sh m03      # + OneAgent
#   ./scripts/validate-lab.sh m04      # + OTel en demo-api
#   ./scripts/validate-lab.sh m05      # + kind + Operator
#   ./scripts/validate-lab.sh all      # todo lo anterior
#
# Códigos de salida: 0 = OK o solo WARN; 1 = ERROR bloqueante
# =============================================================================

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/infra/.env"
CHECKPOINT="${1:-m01}"

errors=0
warns=0

pass() { echo "  OK: $*"; }
warn() { echo "  WARN: $*"; warns=$((warns + 1)); }
fail() { echo "  ERROR: $*"; errors=$((errors + 1)); }

echo "== Validación lab (checkpoint: $CHECKPOINT) =="

# --- Herramientas base ---------------------------------------------------------
for cmd in docker curl; do
  command -v "$cmd" >/dev/null 2>&1 && pass "$cmd disponible" || fail "$cmd no encontrado"
done

if docker compose version >/dev/null 2>&1; then
  pass "docker compose v2"
else
  fail "docker compose v2 no disponible"
fi

# --- .env ----------------------------------------------------------------------
if [[ ! -f "$ENV_FILE" ]]; then
  fail "Falta $ENV_FILE — ejecuta: cp infra/.env.example infra/.env"
else
  pass "infra/.env existe"
  # shellcheck disable=SC1090
  set -a
  # shellcheck source=/dev/null
  source "$ENV_FILE"
  set +a

  [[ -n "${DYNATRACE_ENVIRONMENT_URL:-}" ]] && pass "DYNATRACE_ENVIRONMENT_URL definida" \
    || warn "DYNATRACE_ENVIRONMENT_URL vacía"
  [[ -n "${ONEAGENT_PAAS_TOKEN:-}" ]] && pass "ONEAGENT_PAAS_TOKEN definido" \
    || warn "ONEAGENT_PAAS_TOKEN vacío (necesario en M03)"
  [[ -n "${DYNATRACE_API_TOKEN:-}" ]] && pass "DYNATRACE_API_TOKEN definido" \
    || warn "DYNATRACE_API_TOKEN vacío (necesario en M05)"
  [[ -n "${DYNATRACE_INGEST_TOKEN:-}" ]] && pass "DYNATRACE_INGEST_TOKEN definido" \
    || warn "DYNATRACE_INGEST_TOKEN vacío (necesario en M04/M05)"

  if [[ -n "${DYNATRACE_ENVIRONMENT_URL:-}" ]]; then
    case "${DYNATRACE_ENVIRONMENT_URL}" in
      */ui/*) fail "URL contiene /ui/ — usa solo https://<id>.live.dynatrace.com" ;;
      *) pass "URL sin ruta /ui/" ;;
    esac
  fi
fi

# --- Stack Docker (M01+) -------------------------------------------------------
echo ""
echo "-- Stack Docker --"
cd "$ROOT/infra"

if docker compose ps --status running 2>/dev/null | grep -q demo-api; then
  pass "demo-api running"
else
  fail "demo-api no running — ejecuta: ./scripts/lab-up.sh"
fi

if curl -sf "http://127.0.0.1:8080/" >/dev/null 2>&1; then
  pass "demo-web :8080 responde"
else
  fail "demo-web :8080 no responde"
fi

if curl -sf "http://127.0.0.1:8081/health" >/dev/null 2>&1; then
  pass "demo-api :8081/health responde"
else
  fail "demo-api :8081/health no responde"
fi

need_m03=false
need_m04=false
need_m05=false
case "$CHECKPOINT" in
  m03|m04|m05|all) need_m03=true ;;
esac
case "$CHECKPOINT" in
  m04|all) need_m04=true ;;
esac
case "$CHECKPOINT" in
  m05|all) need_m05=true ;;
esac

# --- OneAgent (M03+) -----------------------------------------------------------
if $need_m03; then
  echo ""
  echo "-- OneAgent (M03) --"
  if docker ps --format '{{.Names}}' 2>/dev/null | grep -qx dynatrace-oneagent; then
    status="$(docker inspect dynatrace-oneagent --format '{{.State.Status}}' 2>/dev/null || echo unknown)"
    restarts="$(docker inspect dynatrace-oneagent --format '{{.RestartCount}}' 2>/dev/null || echo 0)"
    if [[ "$status" == "running" ]]; then
      pass "contenedor dynatrace-oneagent Up (restarts=$restarts)"
    else
      fail "dynatrace-oneagent status=$status — ./scripts/oneagent-status.sh"
    fi
  else
    fail "OneAgent no desplegado — ./scripts/oneagent-up.sh"
  fi
fi

# --- OTel demo-api (M04+) ------------------------------------------------------
if $need_m04; then
  echo ""
  echo "-- OpenTelemetry demo-api (M04) --"
  if grep -q "opentelemetry" "$ROOT/infra/demo-web/requirements.txt" 2>/dev/null; then
    pass "requirements.txt incluye OpenTelemetry"
  else
    fail "Falta OTel en requirements.txt — ver M04-01 paso 4 o labs/solutions/M04/"
  fi
  if grep -q "_configure_otel" "$ROOT/infra/demo-web/api.py" 2>/dev/null; then
    pass "api.py incluye _configure_otel()"
  else
    fail "Falta _configure_otel() en api.py — ver M04-01 paso 5"
  fi
  if grep -q 'CMD \["python", "api.py"\]' "$ROOT/infra/demo-web/Dockerfile.api" 2>/dev/null; then
    pass "Dockerfile.api usa python api.py (sin doble instrumentación)"
  elif grep -q "opentelemetry-instrument" "$ROOT/infra/demo-web/Dockerfile.api" 2>/dev/null; then
    fail "Dockerfile.api usa opentelemetry-instrument — quitar; ver M04-01 paso 7"
  else
    fail "Dockerfile.api CMD inesperado — ver M04-01 paso 7"
  fi
  if curl -sf "http://127.0.0.1:8081/work" >/dev/null 2>&1; then
    pass "GET /work responde tras rebuild"
  else
    warn "GET /work no responde — rebuild: docker compose -f infra/docker-compose.yml up -d --build demo-api"
  fi
fi

# --- Kubernetes (M05+) ---------------------------------------------------------
if $need_m05; then
  echo ""
  echo "-- Kubernetes + Operator (M05) --"
  command -v kind >/dev/null 2>&1 && pass "kind instalado" || fail "kind no instalado — postCreate o setup-codespace.sh"
  command -v kubectl >/dev/null 2>&1 && pass "kubectl instalado" || fail "kubectl no instalado"
  command -v envsubst >/dev/null 2>&1 && pass "envsubst instalado" || fail "envsubst no instalado — apt install gettext-base"

  if kind get clusters 2>/dev/null | grep -qx dynatrace-lab; then
    pass "clúster kind-dynatrace-lab existe"
    if kubectl --context kind-dynatrace-lab get nodes 2>/dev/null | grep -q Ready; then
      pass "nodo kind Ready"
    else
      fail "nodo kind no Ready"
    fi
  else
    fail "clúster kind-dynatrace-lab no existe — ./scripts/kind-up.sh"
  fi

  if kubectl --context kind-dynatrace-lab -n dynatrace get dynakube dynatrace-lab 2>/dev/null | grep -q dynatrace-lab; then
    pass "DynaKube dynatrace-lab aplicado"
  else
    fail "DynaKube no encontrado — ./scripts/operator-up.sh"
  fi

  if kubectl --context kind-dynatrace-lab -n dynatrace-lab get deploy lab-web 2>/dev/null | grep -q lab-web; then
    pass "workload lab-web desplegado"
  else
    warn "lab-web no desplegado — ./scripts/k8s-lab-up.sh"
  fi
fi

echo ""
if [[ $errors -gt 0 ]]; then
  echo "Resultado: $errors error(es), $warns aviso(s). Corrige antes de continuar."
  echo "Ayuda: labs/TROUBLESHOOTING.md"
  exit 1
fi

echo "Resultado: OK ($warns aviso(s)). Puedes continuar el lab en Dynatrace UI."
exit 0
