---
name: roadmap
description: Organizar épicas y tareas en un plan temporal con hitos claros
version: 1.0.0
agent: planner
---

## Cuándo usar

Cuando el plan tiene múltiples épicas y hay que decidir orden de entrega o hay una fecha límite.

## Nivel 1 — Roadmap básico

1. Toma las épicas del `breakdown.md`
2. Identifica las dependencias entre épicas (¿cuál bloquea a cuál?)
3. Asigna cada épica a una fase (Fase 1, 2, 3...)
4. Cada fase debe ser entregable de forma independiente (valor incremental)

## Nivel 2 — Si hay fecha límite

- Toma los puntos de estimación de `estimation.md`
- Divide el tiempo disponible en fases iguales
- Asigna épicas a fases respetando que el total de puntos no exceda la capacidad
- Marca como "fuera de alcance" lo que no cabe y señálalo al Orquestador

## Nivel 3 — Roadmap con riesgos

Para proyectos con alta incertidumbre:
- Marca tareas con `[RIESGO]` que dependen de decisiones aún no tomadas
- Propón un "spike" (investigación breve) para reducir el riesgo antes de comprometerse
- Indica qué cambiaría en el plan si el riesgo se materializa

## Formato de Output

```
Roadmap: <nombre del proyecto>

Fase 1 — <nombre> (objetivo: <valor entregable>)
  Épica 1: X  [~3 puntos]
  Épica 2: Y  [~2 puntos]

Fase 2 — <nombre>
  Épica 3: Z  [~5 puntos]  [RIESGO: depende de decisión de Architect]

Fuera de alcance (si aplica):
  - Épica 4: W  [~8 puntos]
```
