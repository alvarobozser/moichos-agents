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
  hooks/                    ← Scripts pre/post tarea
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


## Recursos

- [Convenciones del proyecto](.agents/shared/resources/conventions.md)
- [Referencias y benchmarks](.agents/shared/resources/references.md)
- [Manifiesto completo del sistema](.agents/MANIFEST.md)
- [agentskills.io — convención de skills](https://agentskills.io/skill-creation/quickstart)
- [Model Context Protocol](https://modelcontextprotocol.io)
