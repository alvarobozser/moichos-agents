---
name: design
description: Definir la estructura y los contratos de un nuevo módulo o sistema
version: 1.0.0
agent: architect
---

## Cuándo usar

Cuando hay que decidir cómo organizar código nuevo que afecta a más de un módulo o introduce una nueva capa.

## Nivel 1 — Decisión mínima

1. Define el límite del módulo: ¿qué entra y qué sale?
2. Establece el contrato público (interfaces, tipos, API)
3. Elige el patrón estructural que mejor se ajusta al problema (no inventes uno nuevo)
4. Entrega instrucciones concretas al Coder: estructura de carpetas, nombres, interfaces

## Nivel 2 — Opciones a evaluar

Para cada decisión de diseño no trivial, evalúa al menos 2 alternativas:

| Criterio | Opción A | Opción B |
|----------|---------|---------|
| Simplicidad | | |
| Extensibilidad | | |
| Acoplamiento | | |
| Coste de cambio futuro | | |

Elige la opción más simple que cumpla los requisitos actuales. No diseñes para el futuro hipotético.

## Nivel 3 — Arquitectura hexagonal / limpia

Cuando el proyecto requiere desacoplar dominio de infraestructura:
- El dominio no importa nada de infraestructura
- Los adaptadores implementan puertos (interfaces del dominio)
- La dirección de dependencia siempre apunta hacia dentro (hacia el dominio)
- Ver referencia: `shared/resources/conventions.md`

## Output

```
Decisión de diseño: <nombre>

Estructura propuesta:
  src/domain/<módulo>/
    <entity>.ts
    <repository>.interface.ts
    <service>.ts

Contrato público:
  interface <Repository> {
    findById(id: string): Promise<<Entity> | null>
    save(entity: <Entity>): Promise<void>
  }

Instrucciones para Coder:
  1. Crear la interfaz antes que la implementación
  2. La implementación va en src/infrastructure/<módulo>/
  3. Inyectar por constructor, no instanciar directamente
```
