---
name: routing-feedback
description: Emitir veredicto estructurado y redirigir problemas al agente responsable
version: 1.0.0
agent: reviewer
---

## Cuándo usar

Después de aplicar `code-review.md`. Esta skill produce el output que el Orquestador parsea para decidir qué hacer.

## Nivel 1 — Veredicto sin problemas

```
✓ APROBADO
Revisado: código, tests, docs
Notas: [observaciones informativas, si las hay]
```

## Nivel 2 — Veredicto con problemas

Cada problema lleva: agente responsable, localización, descripción concisa.

```
✗ RECHAZADO
Problemas:

  [coder]    src/domain/user.ts:45         — función con más de 3 responsabilidades
  [tester]   src/domain/user.ts            — falta test para el caso email duplicado
  [security] src/api/auth.ts:12            — token sin expiración definida
  [docs]     src/api/users.ts              — endpoint POST /users sin documentar
  [frontend] src/components/LoginForm.tsx  — falta aria-label en el campo email
```

## Nivel 3 — Problemas en múltiples rondas

Si el mismo problema aparece por segunda vez:

```
✗ RECHAZADO (2ª ronda)
Problemas sin resolver de la ronda anterior:
  [coder] src/domain/user.ts:45 — MISMO PROBLEMA (persiste tras corrección)
  Descripción más detallada: <por qué la corrección no es suficiente>

Escalar al usuario si aparece por 3ª vez.
```

## Tabla de responsabilidades

| Tipo de problema | Agente responsable |
|-----------------|-------------------|
| Bug lógico, código incorrecto | coder |
| Test faltante o fallido | tester |
| Vulnerability o secret expuesto | security |
| Violación de arquitectura | architect |
| Docs ausentes o incorrectas | docs |
| Problema de UI o accesibilidad | frontend |
| Requisito no implementado | planner → coder |
