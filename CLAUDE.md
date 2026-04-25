# AgenticAI — Sistema Multi-Agente

## Inicio obligatorio para cualquier agente o LLM

**Carga este fichero primero, luego carga el manifiesto:**

```
.agents/MANIFEST.md
```

El manifiesto contiene el registro completo de agentes, skills, MCPs, hooks y recursos del sistema.

## Comportamientos Personalizados

**Saludo**: Cuando el usuario salude (hola, hey, buenas, ¿cómo estás?, etc.), responder con un saludo breve e incluir el icono 🐢 para confirmar que el sistema está cargado.

## Propósito del Workspace

Workspace personal para explorar agentes IA, sistemas autónomos y herramientas basadas en agentes. Contiene un sistema multi-agente portable y reutilizable.

## Estructura del Sistema de Agentes

```
.agents/
  MANIFEST.md               ← ENTRADA PRINCIPAL (cárgalo primero)
  orchestrator/             ← Orquestador: delega, nunca ejecuta
  agents/
    planner/                ← Descompone requisitos en planes
    coder/                  ← Implementa código
    tester/                 ← Escribe y ejecuta tests
    architect/              ← Diseño y ADRs
    security/               ← Auditoría OWASP
    reviewer/               ← Valida todo el output (siempre último)
    docs/                   ← Genera documentación
    frontend/               ← UI/UX y accesibilidad
  shared/
    skills/                 ← Skills reutilizables (git, filesystem)
    resources/              ← Convenciones y referencias
  mcps/                     ← Configuraciones MCP por agente
  hooks/                    ← Pre/post tarea (.sh y .ps1)
```

## Compatibilidad Multi-LLM

| LLM | Fichero |
|-----|---------|
| Claude Code | `CLAUDE.md` (carga automática) |
| GitHub Copilot | `.github/copilot-instructions.md` (carga automática) |
| OpenCode | `opencode.json` (agentes nativos) |

## Portabilidad

Para usar este sistema en otro proyecto: copia `.agents/` y los ficheros de manifiesto listados arriba. Ver instrucciones detalladas en `.agents/MANIFEST.md`.

## Convenciones

Ver `.agents/shared/resources/conventions.md` para la fuente de verdad de estándares de código.

## Referencias

Ver `.agents/shared/resources/references.md` para links curados a benchmarks, arquitectura y seguridad.
