# M04-01 — Servicios y trazas

[← Página anterior](README.md) · [Siguiente página →](M04-02-problems-davis.md)

> Práctica del módulo. Requiere M03-01 (OneAgent) y stack demo activo.

### Objetivo

Localizar el servicio demo-api en Dynatrace y seguir un PurePath completo hasta PostgreSQL.

### Prerrequisitos

- M03 completado.
- `./scripts/lab-up.sh` en marcha.

### En qué consiste

Generas tráfico HTTP, abres Distributed traces, filtras por servicio y analizas spans y tiempos.

### 1 — Generar tráfico

**Acción:** En una terminal del Codespace:

```bash
./scripts/generate-load.sh http://127.0.0.1:8081 90
```

**Por qué:** Sin transacciones recientes no hay PurePaths que analizar.
**Resultado esperado:** Script corre ~90 s sin errores de conexión.

### 2 — Abrir servicios

**Acción:** En Dynatrace, abre **Services** (o **Distributed traces → Services**). Busca un servicio relacionado con `demo-api`, Flask o el puerto **8081**.
**Por qué:** Confirma que la instrumentación full-stack detectó el endpoint HTTP.
**Resultado esperado:** Servicio con tráfico en los últimos 15 minutos.

### 3 — Filtrar trazas

**Acción:** Abre **Distributed traces**. Filtra por el servicio del paso anterior y por timeframe **Last 30 minutes**.
**Por qué:** Reduce ruido de otras entidades del host.
**Resultado esperado:** Lista de trazas con duración y resultado (success/fail).

### 4 — Analizar un PurePath de `/work`

**Acción:** Abre una traza asociada a `GET /work`. Expande spans hasta ver actividad de base de datos o downstream hacia Postgres/Redis.
**Por qué:** El endpoint `/work` ejecuta `SELECT 1` y operaciones Redis — deben reflejarse en la traza.
**Resultado esperado:** Cadena request → aplicación → dependencia (DB o cache).

### 5 — Request attributes

**Acción:** En el detalle de la traza, localiza **Request attributes** o metadatos HTTP (método, URL, status code).
**Por qué:** En Associate debes leer atributos para filtrar incidentes.
**Resultado esperado:** Método `GET`, path `/work`, código 200.

## Comprueba tu entendimiento

**Latencia dominante**
En un PurePath de `/work`, indica qué span consume más tiempo (app vs DB vs red).
→ Identificas un span con mayor duración relativa.

## Reto

### 1 — Comparar `/work` y `/slow`

Ejecuta manualmente:

```bash
curl -s http://127.0.0.1:8081/work
curl -s http://127.0.0.1:8081/slow
```

Localiza una traza de cada endpoint y compara duración total.
→ `/slow` claramente más lento (≈3 s).

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| Sin servicios | Poco tráfico o delay ingest | Repite generate-load; espera 5 min |
| Servicio genérico «Python» | Naming aún no consolidado | Filtra por puerto 8081 o proceso Flask |
| Trazas vacías | OneAgent sin deep monitoring | Verifica OneAgent Connected |

## Referencia

- Endpoints lab: `infra/demo-web/api.py`
- Script: `scripts/generate-load.sh`
