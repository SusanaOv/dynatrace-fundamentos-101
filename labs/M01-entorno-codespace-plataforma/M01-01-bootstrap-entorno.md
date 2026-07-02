# M01-01 — Bootstrap del entorno

[← Página anterior](README.md) · [Siguiente página →](M01-02-navegacion-ui.md)

> Práctica del módulo. La teoría y la demo están en el [README del módulo](README.md).

### Objetivo

Dejar operativo tu fork, Codespace, tenant Dynatrace y stack Docker del curso.

### Prerrequisitos

- Cuenta GitHub.
- Tenant Dynatrace SaaS (trial gratuito).

### En qué consiste

Fork del repo, arranque del Codespace, configuración de `infra/.env`, despliegue de Compose y validación con `health-check.sh`.

### 1 — Fork y Codespace

**Acción:** Haz fork de `my-it-labs/dynatrace-fundamentos-101`, abre **Code → Codespaces → Create codespace on main**.
**Por qué:** Cada alumno trabaja en su copia y conserva el material al finalizar.
**Resultado esperado:** Terminal en `/workspaces/dynatrace-fundamentos-101` (o nombre de tu fork).

### 2 — Tenant y tokens

**Acción:** Crea o accede a tu tenant en [dynatrace.com/signup](https://www.dynatrace.com/signup/). Genera y guarda:

| Token | Cuándo lo usas |
|-------|----------------|
| **PaaS** | **M03** — instalar OneAgent (`ONEAGENT_PAAS_TOKEN`) |
| **Operator** + **Ingest** | **M05** — Kubernetes (app Kubernetes → Add cluster) |

**Por qué:** M01 solo prepara el tenant; no hace falta desplegar OneAgent todavía.
**Resultado esperado:** URL tipo `https://<env-id>.live.dynatrace.com` y tokens en gestor seguro (no en el chat ni en git).

### 3 — Configurar `.env`

**Acción:** En el Codespace, edita `infra/.env` (copiado desde `.env.example`) con `DYNATRACE_ENVIRONMENT_URL`, tokens e `DYNATRACE_ENVIRONMENT_ID`.
**Por qué:** Los scripts y módulos posteriores leen esta configuración.
**Resultado esperado:** `source infra/.env && echo $DYNATRACE_ENVIRONMENT_URL` muestra tu URL.

### 4 — Levantar el lab

**Acción:** Ejecuta `./scripts/lab-up.sh` desde la raíz del repo.
**Por qué:** Despliega demo-web, demo-api, Postgres, Redis y loadgen.
**Resultado esperado:** `./scripts/health-check.sh` reporta `demo-web :8080 OK` y `demo-api :8081 OK`.

## Comprueba tu entendimiento

**Stack en marcha**
Ejecuta `docker compose -f infra/docker-compose.yml ps` y verifica que los cinco servicios están `running`.
→ Cinco contenedores activos sin reinicios en bucle.

## Reto

### 1 — Identifica tu entorno

Anota (para ti) el ID de environment Dynatrace y la URL pública del puerto 8080 que Codespaces reenvía al demo-web.

<details>
<summary>Ver orientación</summary>

El environment ID es el prefijo de la URL del tenant. El puerto 8080 aparece en la pestaña **Ports** del Codespace o al abrir el enlace forwarded.

</details>

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `demo-api FAIL` | Postgres aún no healthy | Espera 30 s y repite health-check |
| Docker permission denied | Daemon no listo tras crear Codespace | Reabre terminal o espera postCreate |
| URL tenant incorrecta | Incluye `/apps` o barra final | Usa solo `https://<id>.live.dynatrace.com` |
