# M04-02 — Problems Davis

[← Página anterior](M04-01-servicios-trazas.md) · [Siguiente página →](../M05-kubernetes-operator/README.md)

> **Formato del lab:** **dónde** · **acción** · **para qué** · **validar** · **comprender**.

---

## Punto de partida (starter)

| Elemento | Estado |
|----------|--------|
| M04-01 | Completado — OTel en `api.py`, spans `GET /work` visibles |
| Endpoints | `/fail` y `/slow` disponibles sin cambios de código |

---

### Objetivo

Provocar un problem en el lab, analizar impacto y causa raíz sugerida por Davis, y proponer acción correctiva.

### Prerrequisitos

- M04-01 completado.

### En qué consiste

Induces errores y latencia, monitorizas **Problems**, abres el detalle del problem y lo relacionas con trazas y servicio demo-api.

### 1 — Inducir fallos

**Acción:** Ejecuta durante 2–3 minutos:

```bash
for i in $(seq 1 60); do
  curl -sf http://127.0.0.1:8081/fail >/dev/null || true
  curl -sf http://127.0.0.1:8081/slow >/dev/null || true
  sleep 2
done
```

**Por qué:** `/fail` (HTTP 500) y `/slow` (latencia) son señales que Davis puede correlacionar.
**Resultado esperado:** Tráfico de error y latencia visible en el servicio.

### 2 — Abrir Problems

**Acción:** En Dynatrace, abre **Problems**. Filtra por timeframe reciente y estado **Open** o **Closed** (última hora).
**Por qué:** Problems es la vista operativa principal para incidentes automáticos.
**Resultado esperado:** Al menos un problem relacionado con demo-api, latencia o failure rate.

### 3 — Analizar impacto

**Acción:** Abre el problem. Lee **Impact** (servicios/host afectados) y **Severity**.
**Por qué:** Priorizas según blast radius, no solo el síntoma.
**Resultado esperado:** demo-api (o servicio equivalente) listado como afectado.

### 4 — Root cause

**Acción:** Revisa la sección **Root cause** / **Cause** de Davis. Expande evidencias (métricas, trazas, eventos).
**Por qué:** Associate exige explicar *por qué* ocurrió, no solo *qué* falló.
**Resultado esperado:** Causa coherente (p. ej. aumento de response time o error rate en demo-api).

### 5 — Evidencia en trazas

**Acción:** Desde el problem, salta a **Related traces** o abre Distributed traces filtrando errores (`failed` / status 5xx).
**Por qué:** Cierras el ciclo Problem → PurePath → endpoint `/fail`.
**Resultado esperado:** Trazas con status 500 en `/fail`.

## Comprueba tu entendimiento

**Acción recomendada**
En una frase, ¿qué harías en producción si `/fail` fuera un bug real? (rollback, fix, scale…)
→ Respuesta operativa razonable vinculada al síntoma observado.

## Reto

### 1 — Cerrar el ciclo

Tras detener el bucle de errores, observa si el problem se **cierra** automáticamente tras unos minutos.
→ Problem pasa a resolved/closed cuando las métricas vuelven a baseline.

<details>
<summary>Ver orientación</summary>

Davis usa baselines; al cesar `/fail`, la tasa de error debería normalizarse y el problem cerrarse solo.

</details>

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| No aparece problem | Baseline aún aprendiendo | Repite carga 5+ min |
| Problem genérico | Mucho ruido en host | Filtra por servicio demo-api |
| Root cause vacía | Pocos datos | Mantén carga + espera ingest |
