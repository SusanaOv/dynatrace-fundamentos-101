# M03-01 — OneAgent en Compose

[← Página anterior](README.md) · [Siguiente página →](M03-02-procesos-bases-datos.md)

> Práctica del módulo. La teoría y la demo están en el [README del módulo](README.md).

### Objetivo

Desplegar OneAgent en el Codespace y confirmar que Dynatrace monitoriza el host y los contenedores del laboratorio.

### Prerrequisitos

- M01-01 completado (`./scripts/lab-up.sh` OK).
- **PaaS token** generado en el tenant Dynatrace.

### En qué consiste

Configuras `ONEAGENT_PAAS_TOKEN`, ejecutas el script del curso, esperas la conexión y verificas entidades de infraestructura en la UI.

### 1 — Generar PaaS token

**Acción:** En Dynatrace, abre **Access tokens** (o Hub → **OneAgent** → **Set up** → **Linux**). Genera un token de tipo **PaaS** con permisos de instalación de OneAgent.
**Por qué:** El contenedor `dynatrace/oneagent` descarga el instalador autenticándose con este token.
**Resultado esperado:** Token copiado de forma segura (no en el repositorio).

### 2 — Rellenar `infra/.env`

**Acción:** Añade a `infra/.env`:

```bash
DYNATRACE_ENVIRONMENT_URL=https://<tu-env-id>.live.dynatrace.com
DYNATRACE_ENVIRONMENT_ID=<tu-env-id>
ONEAGENT_PAAS_TOKEN=<paas-token>
```

**Por qué:** `scripts/oneagent-up.sh` construye la URL del instalador a partir del tenant si no defines `ONEAGENT_INSTALLER_SCRIPT_URL`.
**Resultado esperado:** Variables presentes sin commitear el fichero (`.env` está en `.gitignore`).

### 3 — Desplegar OneAgent

**Acción:** Desde la raíz del repo ejecuta:

```bash
./scripts/oneagent-up.sh
./scripts/oneagent-status.sh
```

**Por qué:** Levanta el contenedor `dynatrace-oneagent` en modo `--privileged` con `--pid=host` y `--network=host`, patrón recomendado para Docker sin orquestador.
**Resultado esperado:** Contenedor `running`; logs sin errores repetidos de descarga/instalación.

### 4 — Validar en Dynatrace

**Acción:** Abre **Deployments → OneAgents** (o **Infrastructure → OneAgents** según tu versión de UI). Busca el host del Codespace.
**Por qué:** Confirma conectividad tenant ↔ OneAgent antes de analizar métricas.
**Resultado esperado:** OneAgent **Connected** / **Monitoring** en el host.

### 5 — Esperar descubrimiento de contenedores

**Acción:** Mantén `./scripts/lab-up.sh` activo. Espera **2–5 minutos**. Abre **Infrastructure → Hosts** → tu host → pestaña/sección **Containers** (o **Processes**).
**Por qué:** El descubrimiento de contenedores Docker no es instantáneo.
**Resultado esperado:** Contenedores `infra-demo-api-1`, `infra-postgres-1`, `infra-redis-1`, etc.

## Comprueba tu entendimiento

**Host visible**
En Infrastructure, localiza el host del Codespace y comprueba que muestra métricas de CPU/memoria en los últimos 5 minutos.
→ Gráficas con datos, no «No data».

**Contenedores del lab**
Identifica al menos tres contenedores cuyo nombre contenga `demo-api`, `postgres` o `redis`.
→ Aparecen vinculados al host del Codespace.

## Reto

### 1 — Reinicio controlado

Para el contenedor OneAgent con `./scripts/oneagent-down.sh`, vuelve a levantarlo y comprueba que el host reconecta sin reinstalar manualmente el token.

<details>
<summary>Ver orientación</summary>

Tras `oneagent-down` + `oneagent-up`, el host puede tardar unos minutos en volver a **Connected**. Los tokens en `.env` deben seguir siendo válidos.

</details>

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `ERROR: ONEAGENT_PAAS_TOKEN vacío` | `.env` sin token | Genera PaaS token y rellena `.env` |
| OneAgent container exit / crash loop | Token inválido o URL mal formada | Revisa URL sin `/apps`; regenera token |
| Sin contenedores en UI | Lab parado o poco tiempo de espera | `lab-up.sh` + espera 5 min |
| `permission denied` Docker | Daemon aún iniciando | Reintenta tras 30 s en Codespace |
| Logs: download failed | Firewall o tenant incorrecto | Verifica HTTPS saliente y environment ID |

## Referencia

- Script del curso: `scripts/oneagent-up.sh`
- Documentación: [OneAgent as Docker container](https://docs.dynatrace.com/docs/ingest-from/setup-on-container-platforms/docker/set-up-dynatrace-oneagent-as-docker-container)
