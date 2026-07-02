# Troubleshooting — Dynatrace Fundamentos

## Stack Docker (M01)

| Problema | Solución |
|----------|----------|
| `demo-api FAIL` | `docker compose -f infra/docker-compose.yml logs demo-api` — suele ser Postgres aún no healthy |
| Puertos ocupados | `docker compose -f infra/docker-compose.yml down` y reintenta |
| Sin Docker | Espera `postCreate` del Codespace o reinicia el Codespace |

## OneAgent (M03)

| Problema | Solución |
|----------|----------|
| Token PaaS inválido | Regenera en Access tokens; actualiza `ONEAGENT_PAAS_TOKEN` |
| Contenedor OA reinicia | `docker logs dynatrace-oneagent` — revisa URL y token |
| Sin contenedores en UI | Confirma `lab-up.sh`; espera 5 min; OneAgent Connected |
| `--privileged` denegado | Poco habitual en Codespaces; contacta formador |

## Dynatrace UI

| Problema | Solución |
|----------|----------|
| UI distinta a capturas | Usa búsqueda global (<kbd>Ctrl</kbd>+<kbd>K</kbd>) por nombre de app |
| Sin datos recientes | Verifica zona horaria del tenant; genera carga con curl al demo-api |
| Mezcla con otros alumnos | Filtra por hostname del Codespace |

## Comandos útiles

```bash
./scripts/lab-up.sh
./scripts/lab-down.sh
./scripts/oneagent-up.sh
./scripts/oneagent-down.sh
./scripts/oneagent-status.sh
./scripts/generate-load.sh
docker compose -f infra/docker-compose.yml ps
docker logs -f dynatrace-oneagent
```
