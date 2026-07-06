# Laboratorios — cómo están organizados

Cada lab sigue la misma lógica:

1. **Punto de partida (starter)** — qué hay en el repo y qué ya deberías tener hecho.
2. **Pasos** — tú ejecutas acciones en terminal, ficheros o UI Dynatrace.
3. Por paso: **dónde** · **acción** · **para qué** · **validar** · **comprender**.
4. **Cierre** — preguntas para comprobar que entiendes, no solo que “sale verde”.

El código de aplicación (`api.py`, etc.) llega en versión **starter**. Los cambios (p. ej. OpenTelemetry en M04) **los haces tú** siguiendo el lab.

Si algo falla → [TROUBLESHOOTING.md](TROUBLESHOOTING.md) (diagnóstico paso a paso; no adivinar).

| Módulo | Labs | ¿Modificas código? |
|--------|------|-------------------|
| M01 | Bootstrap, UI | `.env` solo |
| M02 | Smartscape, naming | No |
| M03 | OneAgent, procesos | No (scripts del repo) |
| M04 | Trazas, Problems | **Sí** — OTel en `api.py` |
| M05 | kind, Operator | `.env` + scripts |
| M06 | Dashboards, DQL | No |
