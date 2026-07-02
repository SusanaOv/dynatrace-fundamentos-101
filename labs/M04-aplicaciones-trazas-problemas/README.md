# M04 — Servicios, trazas y problemas

[← Página anterior](../M02-arquitectura-smartscape/M02-02-entidades-naming.md) · [Siguiente página →](M04-01-servicios-trazas.md)

> [!NOTE]
> **Cómo funciona este módulo.** Teoría → demostración guiada → laboratorios.

## Qué aprenderás

- Identificar **servicios** instrumentados a partir del demo-api.
- Seguir **PurePaths** (trazas distribuidas) de extremo a extremo.
- Interpretar **Problems** detectados por **Davis AI** y su causa raíz.

## Teoría

### De proceso a servicio

OneAgent promueve procesos con tráfico HTTP/gRPC a entidades **Service**. En el lab, `demo-api` (Flask en :8081) aparece como servicio con métodos/endpoints (`/work`, `/health`, …).

### PurePath

Un **PurePath** es la traza completa de una transacción: entrada → código → llamadas a Redis/Postgres → salida. Permite ver latencia por hop y errores por span.

### Problems y Davis

**Davis** correlaciona métricas, trazas y eventos. Un **Problem** agrupa síntomas (p. ej. latencia alta, tasa de error) con **impacto** (servicios afectados) y **root cause** sugerida.

| Señal en el lab | Endpoint | Efecto esperado |
|-----------------|----------|-----------------|
| Latencia | `GET /slow` | Response time elevado |
| Error HTTP | `GET /fail` | 500 / failure rate |
| Carga normal | `GET /work` | Tráfico baseline |

## Demostración guiada

> Recorrido del formador (tono descriptivo).

1. Con OneAgent activo y `./scripts/generate-load.sh` en segundo plano, se abre **Distributed traces** filtrando por servicio demo-api.
2. Se selecciona un PurePath de `/work` y se expanden spans hacia PostgreSQL.
3. Se induce `/slow` y `/fail`; en **Problems** aparece un problem reciente con causa ligada al servicio demo-api.

## Ahora practica tú

| Lab | Título | Qué harás |
|-----|--------|-----------|
| M04-01 | [Servicios y trazas](M04-01-servicios-trazas.md) | PurePath del lab |
| M04-02 | [Problems Davis](M04-02-problems-davis.md) | Análisis de causa raíz |

→ Empieza por **[M04-01 — Servicios y trazas](M04-01-servicios-trazas.md)**.
