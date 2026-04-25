---
name: debug
description: Encontrar y corregir la causa raíz de un bug de forma sistemática
version: 1.0.0
agent: coder
---

## Cuándo usar

Cuando se reporta un comportamiento incorrecto o el Tester entrega un test que falla.

## Nivel 1 — Proceso mínimo

1. Reproduce el bug de forma determinista antes de tocar nada
2. Lee el stack trace o el error completo; no adivines
3. Identifica la causa raíz (no el síntoma)
4. Corrige solo la causa raíz; no aprovechas para limpiar código no relacionado

## Nivel 2 — Si no puedes reproducirlo

- Añade logging temporal para capturar el estado justo antes del fallo
- Busca condiciones de carrera (si es asíncrono o concurrente)
- Comprueba si el bug es dependiente de datos específicos o del entorno
- Usa bisección: comenta código hasta que el bug desaparezca, luego reactívalo por partes

## Nivel 3 — Bug difícil de aislar

- Escribe un test de regresión que falle antes de corregir (esto documenta el bug y previene regresiones)
- Si el bug es en código de terceros, verifica la versión de la dependencia y busca issues conocidos
- Si la causa raíz requiere un cambio de arquitectura, señálalo al Orquestador para activar al Architect

## Checklist post-fix

- [ ] Test de regresión escrito y pasando
- [ ] No se introdujeron cambios de comportamiento secundarios
- [ ] El mensaje de commit describe la causa raíz, no el síntoma
