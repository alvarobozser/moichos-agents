---
name: refactor
description: Mejorar la estructura interna del código sin cambiar su comportamiento externo
version: 1.0.0
agent: coder
---

## Cuándo usar

Cuando el Orquestador o el Architect indica que hay código que debe mejorar su legibilidad, mantenibilidad o rendimiento sin alterar lo que hace.

## Nivel 1 — Refactor seguro

1. Confirma que hay tests que cubren el código a refactorizar (si no los hay, para y activa al Tester primero)
2. Haz un cambio a la vez; no mezcles varios refactors en la misma operación
3. Ejecuta los tests después de cada cambio
4. Si un test falla, revierte ese cambio antes de continuar

## Nivel 2 — Técnicas de refactor más comunes

- **Rename**: nombres más descriptivos en variables, funciones y clases
- **Extract function**: extraer lógica repetida o demasiado larga en funciones nombradas
- **Remove duplication**: unificar lógica duplicada en una abstracción
- **Simplify conditionals**: guard clauses en lugar de anidamiento profundo
- **Replace magic number**: extraer constantes con nombre

## Nivel 3 — Refactor estructural (de módulos)

- Requiere aprobación previa del Architect
- Aplica de forma incremental: mueve un módulo a la vez
- Usa adaptadores temporales si hay que mantener compatibilidad durante la transición
- Documenta cada paso para que el Reviewer entienda la dirección

## Restricciones

- Nunca cambia comportamiento observable mientras refactoriza
- Si descubre un bug durante el refactor, lo señala pero no lo corrige en el mismo PR
