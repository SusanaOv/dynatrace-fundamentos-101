# M06-01 — Dashboards y notebooks

[← Página anterior](README.md) · [Siguiente página →](M06-02-logs-dql.md)

> **Formato del lab:** **dónde** · **acción** · **para qué** · **validar** · **comprender**.

---

## Punto de partida (starter)

M03–M04 con datos (host, spans `demo-api` si completaste OTel en M04-01).

---

### Objetivo

Crear un dashboard mínimo para monitorizar salud del demo-api y del host del Codespace.

### Prerrequisitos

- M03–M04 completados (datos de servicio e infraestructura).
- Carga reciente (`./scripts/generate-load.sh` opcional).

### En qué consiste

Añades tiles de métricas clave y guardas el dashboard en tu tenant.

### 1 — Crear dashboard

| | |
|-|-|
| **Dónde** | <kbd>Ctrl</kbd>+<kbd>K</kbd> → **Dashboards** |
| **Acción** | **Create dashboard** → nombre `Lab Dynatrace Fundamentos` |
| **Para qué** | Centralizar métricas del lab en una sola vista |
| **Validar** | Lienzo vacío con botón **Add tile** / **Add chart** |
| **Comprender** | Un dashboard es operación; un notebook es análisis ad hoc (M06 teoría) |

### 2 — Tile response time

| | |
|-|-|
| **Dónde** | Dashboard → **Add tile** |
| **Acción** | Tipo **Service** o **Metric** → servicio **`demo-api`** → métrica **Response time** → timeframe **Last 30 minutes** |
| **Para qué** | Detectar regresiones como `/slow` de M04 |
| **Validar** | Gráfico con puntos si hubo tráfico reciente (`./scripts/generate-load.sh`) |
| **Comprender** | Sin tráfico el tile puede estar vacío — no es error del dashboard |

### 3 — Tile error rate

| | |
|-|-|
| **Dónde** | Mismo dashboard → **Add tile** |
| **Acción** | Métrica **Failure rate** o **HTTP 5xx count** del servicio `demo-api` |
| **Para qué** | Complementa M04-02 (Problems) |
| **Validar** | Pico si ejecutaste `/fail` en la última hora |
| **Comprender** | Correlaciona con Problems pero no lo sustituye |

### 4 — Tile infra host

| | |
|-|-|
| **Dónde** | **Add tile** → categoría **Infrastructure** / **Host** |
| **Acción** | Selecciona el **host del Codespace** → métrica **CPU usage** o **Memory used** |
| **Para qué** | Correlacionar saturación de VM con latencia de app |
| **Validar** | CPU > 0% con lab activo |
| **Comprender** | Host = raíz del árbol que viste en M03 |

### 5 — Guardar y compartir

| | |
|-|-|
| **Dónde** | Barra superior del dashboard |
| **Acción** | **Save** · opcional: enlace solo lectura si tu tenant lo permite |
| **Para qué** | Reutilizar tras el curso en tu fork |
| **Validar** | Dashboard aparece en la lista **Dashboards** al recargar |
| **Comprender** | Los dashboards viven en el tenant, no en el repo git |

## Comprueba tu entendimiento

**Tres tiles**
Enumera qué representa cada tile y qué acción tomarías si response time se duplica.
→ Interpretación coherente (investigar trazas, deployments, carga).

## Reto

### 1 — Maintenance window

Crea una **maintenance window** de 10 min sobre el host del lab. Observa si desaparecen alertas nuevas durante la ventana (si las hay configuradas).

<details>
<summary>Ver orientación</summary>

Settings → Maintenance windows → Add. Selecciona host del Codespace. No abuses en producción real.

</details>

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| Tile sin datos | Sin tráfico reciente | generate-load.sh |
| No encuentro servicio | Nombre distinto | Busca por puerto 8081 o proceso Python |
| Dashboard no guarda | Permisos trial | Guarda en personal scope |
