---
name: coverage
description: Auditar qué lógica no tiene tests y producir un informe de cobertura priorizado
version: 1.0.0
agent: tester
---

## Cuándo usar

Cuando el Reviewer señala cobertura insuficiente o el Orquestador pide un informe de salud del proyecto en materia de tests.

## Nivel 1 — Informe básico

1. Ejecuta la herramienta de cobertura del proyecto (jest --coverage, pytest-cov, etc.)
2. Identifica los ficheros con cobertura < 80% en lógica de negocio
3. Prioriza: primero lógica crítica, luego rutas de error, luego casos borde

## Nivel 2 — Priorización del gap

No toda cobertura al 100% tiene el mismo valor. Prioriza en este orden:

| Prioridad | Qué cubrir |
|-----------|-----------|
| Alta | Lógica de negocio (domain, application) |
| Media | Handlers, controllers, endpoints |
| Baja | Código de infraestructura (adaptadores, clientes HTTP) |
| Opcional | Ficheros de configuración, scripts de build |

## Nivel 3 — Si la cobertura es muy baja (< 40%)

- No intentes cubrir todo de golpe
- Prioriza los módulos que cambian con más frecuencia (ver git log)
- Crea un plan incremental: +10% por sprint hasta llegar al objetivo
- Señala al Orquestador si hay código legacy sin tests que requiere refactor previo

## Formato de Output

```
Informe de Cobertura — <fecha>

Cobertura global: X%
Objetivo: 80%

Gaps prioritarios:
  [ALTA]  src/domain/user-service.ts — 45% — faltan tests para casos de error
  [MEDIA] src/interfaces/user-controller.ts — 60% — falta test de endpoint DELETE
  [BAJA]  src/infrastructure/db-client.ts — 30% — aplazado (código estable)

Próximas acciones:
  [ ] [tester] Tests para UserService.deactivate()
  [ ] [tester] Test de integración para DELETE /users/:id
```
