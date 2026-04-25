---
name: breakdown
description: Descomponer un requisito complejo en tareas atómicas ordenadas por dependencia
version: 1.0.0
agent: planner
---

## Cuándo usar

Cuando el Orquestador entrega un requisito con más de un área de impacto o que no puede ejecutarse en un solo paso.

## Nivel 1 — Inicio rápido

1. Lee el requisito completo de una vez antes de descomponer
2. Identifica las áreas de impacto (backend, frontend, BD, infra, docs)
3. Para cada área, escribe una tarea atómica en formato: `[agente] acción concreta`
4. Ordena las tareas por dependencia (las bloqueantes primero)

## Nivel 2 — Si hay ambigüedad

Si el requisito no está claro en algún punto:
- Marca esa tarea con `[❓ aclarar]` en lugar de inventar
- Lista las preguntas de aclaración al final del plan
- No bloquees el plan completo por una sola incógnita; deja el resto listo

## Nivel 3 — Requisitos muy grandes

Si el desglose supera 10 tareas:
- Agrupa en épicas (máx. 3-4)
- Dentro de cada épica, máx. 3-4 tareas
- Activa la skill `roadmap.md` para ordenarlas temporalmente

## Formato de Output

```
Plan: <nombre del requisito>

Épica 1: <nombre>
  [ ] [coder] implementar X
  [ ] [tester] tests para X
  [❓ aclarar] ¿comportamiento cuando Y?

Épica 2: <nombre>
  [ ] [architect] decidir estructura de Z
  [ ] [coder] implementar Z
  [ ] [frontend] componente para Z
```

## Recursos

- [../resources/templates.md](../resources/templates.md) — Plantillas de desglose por tipo de proyecto
