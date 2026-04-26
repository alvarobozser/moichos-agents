# Agent System Manifest

> **Punto de entrada para el orquestador.** Carga este fichero primero para descubrir todos los agentes, skills y recursos del sistema.

## Registro de Agentes

| ID | Rol | Entrada | Palabras clave |
|----|-----|---------|---------------|
| orchestrator | Orquesta y delega | [orchestrator/agent.md](orchestrator/agent.md) | todas las peticiones |
| planner | Planifica y descompone | [agents/planner/agent.md](agents/planner/agent.md) | plan, estimar, roadmap, desglose, tareas |
| coder | Implementa código | [agents/coder/agent.md](agents/coder/agent.md) | implementar, código, construir, arreglar, refactor |
| tester | Escribe y ejecuta tests | [agents/tester/agent.md](agents/tester/agent.md) | test, cobertura, unitario, integración, e2e |
| architect | Diseña la estructura | [agents/architect/agent.md](agents/architect/agent.md) | arquitectura, diseño, ADR, diagrama, estructura |
| security | Audita vulnerabilidades | [agents/security/agent.md](agents/security/agent.md) | seguridad, auditoría, OWASP, vulnerabilidad, secretos |
| reviewer | Valida todo el output | [agents/reviewer/agent.md](agents/reviewer/agent.md) | revisar, validar, verificar (auto-activado al final) |
| docs | Genera documentación | [agents/docs/agent.md](agents/docs/agent.md) | docs, readme, changelog, API, documentar |
| frontend | Construye UI/UX | [agents/frontend/agent.md](agents/frontend/agent.md) | UI, componente, estilos, frontend, CSS, accesibilidad |

## Modelos por Agente

> Estos son **recomendaciones documentales**, no configuración ejecutable. El modelo real lo fija el LLM que uses.  
> Si un modelo no está disponible, aplica el fallback de la tabla.

| Agente | Modelo preferido | Fallback | Degradación aceptable |
|--------|-----------------|---------|----------------------|
| orchestrator | `claude-sonnet-4-6` | `claude-haiku-4-5-20251001` | Leve — routing más básico |
| planner | `claude-sonnet-4-6` | `claude-haiku-4-5-20251001` | Leve — planes menos detallados |
| coder | `claude-sonnet-4-6` | `claude-haiku-4-5-20251001` | Moderada — código más simple |
| tester | `claude-haiku-4-5-20251001` | `claude-sonnet-4-6` | Ninguna — Sonnet es mejor |
| architect | `claude-opus-4-7` | `claude-sonnet-4-6` | **Alta** — evaluar manualmente las decisiones |
| security | `claude-opus-4-7` | `claude-sonnet-4-6` | **Alta** — revisar el informe manualmente |
| reviewer | `claude-sonnet-4-6` | `claude-haiku-4-5-20251001` | Moderada — revisión menos exhaustiva |
| docs | `claude-haiku-4-5-20251001` | `claude-sonnet-4-6` | Ninguna — Sonnet es mejor |
| frontend | `claude-sonnet-4-6` | `claude-haiku-4-5-20251001` | Moderada — riesgo en accesibilidad |

**Regla para Architect y Security con fallback a Sonnet:**  
Cuando no hay Opus disponible, añade este aviso al output del agente:
> ⚠️ Ejecutado con modelo de fallback (`sonnet-4-6`). Revisar manualmente antes de aceptar.

## Recursos Compartidos

| Recurso | Ruta | Uso |
|---------|------|-----|
| Git skills | [shared/skills/git.md](shared/skills/git.md) | Operaciones git reutilizables |
| Filesystem skills | [shared/skills/filesystem.md](shared/skills/filesystem.md) | Operaciones de ficheros |
| Conventions | [shared/resources/conventions.md](shared/resources/conventions.md) | Estándares de código del proyecto |
| References | [shared/resources/references.md](shared/resources/references.md) | Links externos curados |

## Configuración MCP

### Arquitectura de dos capas

```
/.mcp.json                      ← ACTIVO — Claude Code lo lee aquí (raíz del proyecto)
/.env                           ← credenciales reales (gitignored, cada dev crea el suyo)
/.env.example                   ← plantilla de variables (committed, sin valores reales)
.agents/mcps/global.mcp.json    ← PLANTILLA/documentación (referencia para añadir MCPs)
.agents/mcps/agents/*.mcp.json  ← PLANTILLA por agente (qué MCPs activos por agente)
```

### MCPs activos

| Servidor | Comando | Credencial requerida | Agentes |
|----------|---------|---------------------|---------|
| filesystem | `@modelcontextprotocol/server-filesystem` | ninguna | todos |
| git | `@modelcontextprotocol/server-git` | ninguna | todos |
| github | `@modelcontextprotocol/server-github` | `GITHUB_PERSONAL_ACCESS_TOKEN` en `.env` | orchestrator, reviewer |
| fetch | `@modelcontextprotocol/server-fetch` | ninguna | docs |
| stdio | `@modelcontextprotocol/server-stdio` | ninguna | coder, security |

### Cómo añadir un MCP nuevo

1. Añade la entrada en `/.mcp.json` (el fichero activo)
2. Documenta la plantilla en `.agents/mcps/global.mcp.json`
3. Si necesita credenciales: añade la variable en `.env.example` con instrucciones
4. Cada developer crea su `.env` local con el valor real

### Cómo configurar las credenciales (una vez)

```bash
# 1. Copia la plantilla
cp .env.example .env

# 2. Edita .env con tus tokens reales
# GITHUB_PERSONAL_ACCESS_TOKEN=ghp_tu_token_aqui

# 3. Carga las variables en la sesión actual
source .env   # Bash/Zsh

# PowerShell: ver instrucciones al final de .env.example
```

Ver plantillas detalladas: [mcps/global.mcp.json](mcps/global.mcp.json)

## Hooks de Seguridad

| Evento | Bash | PowerShell | Propósito |
|--------|------|-----------|----------|
| PreToolUse | [hooks/pre-task.sh](hooks/pre-task.sh) | [hooks/pre-task.ps1](hooks/pre-task.ps1) | Bloquea env dumps, lectura de .env y detecta prompt injection |
| Stop | [hooks/post-task.sh](hooks/post-task.sh) | [hooks/post-task.ps1](hooks/post-task.ps1) | Escanea ficheros modificados en busca de secrets |

Registrados en `.claude/settings.json` para Claude Code.

## Skills del Sistema vs Agentes

Algunos skills de Claude Code tienen un agente equivalente más fiable (sin dependencia de bash). El orquestador debe preferir el agente en peticiones de lenguaje natural:

| Skill `/slash` | Agente preferido | Razón |
|---------------|-----------------|-------|
| `/security-review` | `security` | Usa Grep/Read nativos — funciona en todos los entornos |
| `/review` | `reviewer` | Ídem |
| `/simplify` | `reviewer` | Ídem |
| `/update-config`, `/loop`, `/schedule`, `/init`, `/keybindings-help` | — | Sin equivalente, usar directamente |

## Lógica de Enrutamiento

Ver [orchestrator/routing.md](orchestrator/routing.md) para el árbol de decisión completo.

## Compatibilidad Multi-LLM

| LLM | Fichero de instrucciones |
|-----|------------------------|
| OpenCode | `opencode.json` — agentes nativos con prompts apuntando a `.agents/` |
| Claude Code | `CLAUDE.md` → apunta a este sistema |
| Claude / Genérico | `AGENTS.md` → apunta a este sistema |
| GitHub Copilot | `.github/copilot-instructions.md` → apunta a este sistema |

## Instalación en otro proyecto

### Opción A — Desde GitHub (recomendado para compartir con colegas)

Una vez subido el repo a GitHub, cualquier colega ejecuta desde su PC:

```bash
# Unix / Mac / WSL / Git Bash — instala en el directorio actual
curl -sSL https://raw.githubusercontent.com/alvarobozser/moichos-agents/main/bootstrap.sh | bash

# Con directorio destino específico
curl -sSL https://raw.githubusercontent.com/alvarobozser/moichos-agents/main/bootstrap.sh | bash -s -- --target /ruta/proyecto
```

```powershell
# Windows PowerShell — instala en el directorio actual
irm https://raw.githubusercontent.com/alvarobozser/moichos-agents/main/bootstrap.ps1 | iex

# Con directorio destino específico (guardar script primero)
.\bootstrap.ps1 -Target C:\ruta\proyecto
```

### Opción B — Desde esta misma carpeta (ya tienes el repo clonado)

```bash
bash install.sh /ruta/al/proyecto-destino          # Unix
.\install.ps1 -Target C:\ruta\al\proyecto-destino  # Windows
```

Opciones: `--force` / `-Force` sobreescribe ficheros existentes.

### Pasos tras instalar

1. Personaliza `AGENTS.md` con el nombre y propósito del proyecto
2. Edita `.agents/shared/resources/conventions.md` con las convenciones del proyecto
3. Ajusta `.agents/mcps/global.mcp.json` con los MCPs que uses

**Activar el sistema:**
> "Carga `.agents/MANIFEST.md` y actúa como orquestador"
