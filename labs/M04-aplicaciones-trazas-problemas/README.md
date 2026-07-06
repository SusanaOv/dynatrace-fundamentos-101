# M04 — Servicios, trazas y problemas

[← Página anterior](../M02-arquitectura-smartscape/M02-02-entidades-naming.md) · [Siguiente página →](M04-01-servicios-trazas.md)

> [!NOTE]
> **Cómo funciona este módulo.** Teoría → demostración guiada → laboratorios.

## Qué aprenderás

- Contrastar trazas **OneAgent** (nginx/infra) vs **OpenTelemetry** (`demo-api`).
- Seguir spans de `GET /work` hasta Redis y PostgreSQL.
- Interpretar **Problems** detectados por **Davis AI**.

## Teoría

### Dos canales de observabilidad en el lab

| Canal | Qué envía | Qué ves en UI |
|-------|-----------|---------------|
| **OneAgent** (contenedor) | Infra, procesos, HTTP superficial (nginx) | Process group `nginx`, `localhost:80` |
| **OpenTelemetry** (demo-api) | Spans de Flask, Redis, Postgres | Service `demo-api`, vista **Spans** |

### Span y PurePath

Un **span** es un paso (HTTP, query SQL, llamada Redis). Un **PurePath** es la cadena completa. En M04 el waterfall de `GET /work` muestra 3+ spans.

### Problems y Davis

**Davis** correlaciona métricas y trazas. Endpoints del lab:

| Endpoint | Efecto |
|----------|--------|
| `GET /work` | Baseline |
| `GET /slow` | Latencia alta |
| `GET /fail` | HTTP 500 |

## Demostración guiada

1. Alumno confirma límite OneAgent (M03) — solo nginx en Tracing.
2. Alumno **implementa OTel** en `api.py` siguiendo M04-01 (paso a paso).
3. Se contrastan Spans `demo-api` vs trazas nginx; waterfall `/work` con Redis y Postgres.

## Ahora practica tú

| Lab | Título | Qué harás |
|-----|--------|-----------|
| M04-01 | [Servicios y trazas](M04-01-servicios-trazas.md) | **Tú** añades OTel a demo-api; validas spans |
| M04-02 | [Problems Davis](M04-02-problems-davis.md) | Causa raíz |

→ **[M04-01](M04-01-servicios-trazas.md)** — requiere `DYNATRACE_INGEST_TOKEN` en `.env`.
