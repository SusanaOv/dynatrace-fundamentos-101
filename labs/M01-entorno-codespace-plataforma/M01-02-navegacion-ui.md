# M01-02 — Primera navegación en Dynatrace

[← Página anterior](M01-01-bootstrap-entorno.md) · [Siguiente página →](../M02-arquitectura-smartscape/README.md)

> Práctica del módulo. La teoría y la demo están en el [README del módulo](README.md).

### Objetivo

Orientarte en la UI Dynatrace y localizar las apps y vistas que usarás en el curso.

### Prerrequisitos

- M01-01 completado (tenant accesible).

### En qué consiste

Recorrido por Hub, búsqueda global y apps de infraestructura/logs (sin datos de lab aún si OneAgent no está instalado).

### 1 — Hub y búsqueda

**Acción:** Inicia sesión en tu tenant. Abre **Dynatrace Hub** y la **búsqueda global** (<kbd>Ctrl</kbd> + <kbd>K</kbd> o icono de lupa).
**Por qué:** Hub concentra capacidades; la búsqueda acelera navegación en módulos siguientes.
**Resultado esperado:** Localizas apps como **Infrastructure**, **Distributed traces**, **Logs**.

### 2 — Vista de technologies

**Acción:** Abre la app/vista de **Infrastructure** o **Hosts** (nombre puede variar según versión de UI).
**Por qué:** En M03 aparecerán aquí los hosts del Codespace.
**Resultado esperado:** Lista vacía o solo entidades del propio tenant demo; aún normal sin OneAgent.

### 3 — Settings de environment

**Acción:** Navega a **Settings → Preferences → Environment** (ruta equivalente en tu versión).
**Por qué:** Naming rules, maintenance windows y zones se configuran aquí (M06).
**Resultado esperado:** Identificas el nombre del environment de tu trial.

## Comprueba tu entendimiento

**Apps clave**
Enumera tres apps o vistas que usarás antes del final del curso (infra, trazas, logs).
→ Al menos una de infraestructura, una de trazas/servicios y una de logs/dashboards.

## Reto

### 1 — Atajo personal

Guarda en favoritos del navegador la URL directa a Distributed traces o Services.

<details>
<summary>Ver orientación</summary>

Copia la URL tras abrir la app desde el menú; servirá en M04.

</details>

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| UI distinta a capturas del curso | Dynatrace actualiza apps con frecuencia | Usa búsqueda global por nombre de capacidad |
| No ves datos del lab | OneAgent pendiente (M03) | Esperado en M01-02 |
