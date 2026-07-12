# Solución de referencia — M04 OpenTelemetry

> **Usa esto solo si te atascaste** después de intentar M04-01 por tu cuenta.
> El objetivo del curso es que **tú** implementes la instrumentación.

## Aplicar automáticamente

Desde la raíz del repo:

```bash
./scripts/apply-m04-otel-solution.sh
./scripts/validate-lab.sh m04
```

## Qué cambia respecto al starter

| Fichero | Cambio |
|---------|--------|
| `infra/demo-web/api.py` | Función `_configure_otel()` + export OTLP a Dynatrace |
| `infra/demo-web/requirements.txt` | Paquetes OpenTelemetry |
| `infra/demo-web/Dockerfile.api` | `CMD ["python", "api.py"]` (sin `opentelemetry-instrument`) |

Las variables `DYNATRACE_*` ya están cableadas en `infra/docker-compose.yml` (servicio `demo-api`).

## Validar en Dynatrace

1. <kbd>Ctrl</kbd>+<kbd>K</kbd> → **Distributed Tracing** → **Explorer**
2. **Change to spans**
3. Filtro **Service name** = `demo-api`
4. Genera tráfico: `curl http://127.0.0.1:8081/work`

Si no hay spans → [TROUBLESHOOTING](../../TROUBLESHOOTING.md#opentelemetry--demo-api-m04).
