---
name: integration-test
description: Testear flujos completos que atraviesan varios módulos o servicios
version: 1.0.0
agent: tester
---

## Cuándo usar

Cuando el Coder implementa un flujo que cruza varias capas (ej: controller → service → repositorio → BD) o cuando hay integración con servicios externos.

## Nivel 1 — Test de integración básico

1. Identifica el punto de entrada del flujo (endpoint, handler, comando)
2. Usa datos reales de test (no mocks de la BD si es posible)
3. Verifica el estado del sistema después de la operación, no solo el valor de retorno
4. Limpia el estado de test tras cada caso (teardown)

## Nivel 2 — Con servicios externos

- Usa un servidor mock (WireMock, MSW, nock) para dependencias HTTP externas
- Para colas de mensajes: usa una instancia local o un fake en memoria
- Para BD: usa una instancia de test real o un container Docker efímero
- Nunca uses el entorno de producción para tests de integración

## Nivel 3 — Tests de contrato (contract tests)

Para microservicios o APIs consumidas por terceros:
- Define el contrato (OpenAPI, Pact) antes de escribir el test
- El test de contrato verifica que el proveedor cumple lo que el consumidor espera
- Activa al Architect si el contrato no está definido

## Checklist

- [ ] El test reproduce un flujo real de usuario o sistema
- [ ] El estado de la BD o servicio queda limpio después del test
- [ ] No depende de datos de otro test
- [ ] El test es reproducible en cualquier entorno (no hardcodea IPs ni puertos)
