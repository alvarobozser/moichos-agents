# Sistema Multi-Agente

Sistema de agentes IA con un orquestador central que delega tareas a agentes especializados. Compatible con Claude Code, GitHub Copilot y OpenCode.

## ¿Qué incluye?

| Agente | Rol | Modelo |
|--------|-----|--------|
| Orchestrator | Coordina y delega. Nunca ejecuta directamente | Sonnet |
| Planner | Descompone requisitos en tareas atómicas | Sonnet |
| Coder | Implementa código | Sonnet |
| Tester | Escribe tests unitarios y de integración | Haiku |
| Architect | Decisiones de diseño y ADRs | Opus |
| Security | Auditoría OWASP y detección de secrets | Opus |
| Reviewer | Valida todo el output antes de entregar | Sonnet |
| Docs | Genera README, API docs y changelogs | Haiku |
| Frontend | Componentes UI/UX accesibles (WCAG 2.1 AA) | Sonnet |

## Requisitos

- **Node.js** >= 18 (para los servidores MCP via `npx`)
- **Git** (recomendado para el bootstrap; alternativa: `curl`)
- **Un LLM** con soporte de ficheros de instrucciones (Claude Code, Copilot, OpenCode…)

## Instalación en un proyecto existente

### Desde cualquier PC (un solo comando)

```bash
# Unix / Mac / WSL / Git Bash
curl -sSL https://raw.githubusercontent.com/alvarobozser/moichos-agents/main/bootstrap.sh | bash

# Con directorio destino específico
curl -sSL https://raw.githubusercontent.com/alvarobozser/moichos-agents/main/bootstrap.sh | bash -s -- --target /ruta/al/proyecto
```

```powershell
# Windows PowerShell
irm https://raw.githubusercontent.com/alvarobozser/moichos-agents/main/bootstrap.ps1 | iex
```

> **Nota:** Reemplaza `alvarobozser/moichos-agents` con la URL de tu repositorio en GitHub.

### Desde una copia local del repo

```bash
bash install.sh /ruta/al/proyecto          # Unix
.\install.ps1 -Target C:\ruta\al\proyecto  # Windows
```

Ambos comandos aceptan `--force` / `-Force` para sobreescribir si ya existe.

## Mejoras Recientes (v1.1)

- **Fallbacks de modelos ejecutables** — Si un agente falla porque el modelo preferido no está disponible, el orquestador consulta `.agents/mcps/model-fallback.json`, reintenta con el siguiente modelo en la cadena y muestra advertencias de degradación. Ver [protocolo de fallback](.agents/orchestrator/agent.md#protocolo-de-fallback)
- **Routing con criterios objetivos** — Paso 1 ahora usa checklists concretas (no "ambigüedad subjetiva") para decidir cuándo activar Planner/Architect
- **Seguridad preventiva** — Paso 0 detecta ataques de prompt ANTES de clasificar/delegar (no post-facto)

## Configuración tras instalar

### 1. Variables de entorno (credenciales MCP)

```bash
cp .env.example .env
# Edita .env con tus tokens reales
source .env   # Bash/Zsh — o consulta .env.example para PowerShell
```

Necesitas al menos `GITHUB_PERSONAL_ACCESS_TOKEN` para el MCP de GitHub.  
Crea el token en: <https://github.com/settings/tokens> (permisos: `repo`, `issues`, `pull_requests`)

### 2. Personaliza para tu proyecto

Edita estos tres ficheros con los datos de tu proyecto:

| Fichero | Qué personalizar |
|---------|-----------------|
| `AGENTS.md` | Nombre y propósito del proyecto |
| `.agents/shared/resources/conventions.md` | Convenciones de código del equipo |
| `.agents/mcps/global.mcp.json` | MCPs adicionales que uses |

### 3. Activa el sistema en tu LLM

Deberia de cargar de inicio, saluda con un "Hola" y se te contesta con una tortuga, esta cargado.
Si no, escribe esto en tu LLM al comenzar una sesión:

> **"Carga `.agents/MANIFEST.md` y actúa como orquestador"**

## Estructura

```
.agents/
  MANIFEST.md               ← Entrada principal — cárgalo primero
  orchestrator/             ← Lógica de orquestación y routing
  agents/<nombre>/          ← Cada agente con sus skills y recursos
  shared/                   ← Skills y convenciones reutilizables
  mcps/                     ← Configuración de servidores MCP
  hooks/                    ← Scripts pre/post tarea (seguridad)
.claude/
  settings.json             ← Hooks de ciclo de vida (Claude Code)
```

El sistema es **portable**: copia `.agents/` + los ficheros de manifests a cualquier proyecto y funciona desde el primer momento.

## Compatibilidad de LLMs

| LLM | Fichero que carga |
|-----|------------------|
| Claude Code | `CLAUDE.md` |
| OpenCode | `opencode.json` |
| GitHub Copilot | `.github/copilot-instructions.md` |

### OpenCode

Los agentes están configurados de forma nativa en `opencode.json`. Los prompts apuntan directamente a los ficheros `.agents/` con la sintaxis `{file:./ruta}`, por lo que no hay duplicación.

Agentes disponibles en modo `primary` (seleccionables directamente): `orchestrator`, `coder`, `reviewer`.  
El resto son `subagent` (llamados por el orquestador).

## GitHub Actions — Revisión automática de PRs

El proyecto incluye un workflow que revisa **automáticamente todas las PRs con Claude**.

### Configuración rápida

1. **Obtén una API key** de Anthropic: https://console.anthropic.com (plan gratuito: $5/mes)
2. **Añade a Secrets de GitHub:**
   - `Settings → Secrets and variables → Actions`
   - Secret: `ANTHROPIC_API_KEY = <tu-key>`
3. **Listo.** El siguiente PR que abras será revisado automáticamente 🤖

### Flujo

```
PR abierta → GitHub Actions dispara → Claude analiza diff → Comenta resultados
```

### Documentación completa

Ver: [.github/workflows/README.md](.github/workflows/README.md)

---

## Seguridad en Capas

El sistema incluye **dos niveles** de protección contra ataques de prompt injection:

### Nivel 1 — PREVENTIVO (Paso 0 del orquestador)

Antes de clasificar o delegar a agentes, el orquestador verifica:
- ¿El input del usuario contiene patrones maliciosos?
- ¿Algún MCP devolvería contenido externo no confiable?
- ¿Los outputs de MCPs contienen patrones sospechosos?

Si detecta algo: **detiene inmediatamente**, reporta, sin continuar.

### Nivel 2 — DEFENSIVO (Hooks pre-tarea)

Cuando el agente intenta ejecutar una herramienta:

| Protección | Acción |
|------------|--------|
| `env`, `printenv`, `export -p`, `set` | **Bloquea** (exit 2) |
| `cat .env`, `head .env`, etc. | **Bloquea** (exit 2) |
| `/proc/*/environ` | **Bloquea** (exit 2) |
| Patrones de ataque en el input | **Bloquea** (exit 2) |

### Stop — al finalizar la sesión

| Protección | Acción |
|------------|--------|
| Secrets en ficheros modificados (GitHub tokens, API keys, AWS keys, Bearer tokens…) | **Alerta en rojo** |
| Fichero `.env` en el working tree | **Advierte** |

Los hooks están implementados en Bash (`.agents/hooks/pre-task.sh`) y PowerShell (`.agents/hooks/pre-task.ps1`) y se registran automáticamente en `.claude/settings.json` para Claude Code.

## Recursos

- [Lógica de routing y criterios objetivos](.agents/orchestrator/routing.md)
- [Matriz de fallbacks de modelos](.agents/mcps/model-fallback.json)
- [Detección de ataques de prompt](.agents/shared/skills/prompt-injection.md)
- [Manifiesto completo del sistema](.agents/MANIFEST.md)
- [Convenciones del proyecto](.agents/shared/resources/conventions.md)
- [Referencias y benchmarks](.agents/shared/resources/references.md)
- [agentskills.io — convención de skills](https://agentskills.io/skill-creation/quickstart)
- [Model Context Protocol](https://modelcontextprotocol.io)
