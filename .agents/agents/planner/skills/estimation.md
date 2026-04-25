---
name: estimation
description: Estimar el esfuerzo de tareas usando tallas de camiseta (S/M/L/XL)
version: 1.0.0
agent: planner
---

## Cuándo usar

Cuando el Orquestador o el usuario pide saber cuánto cuesta implementar algo antes de hacerlo.

## Nivel 1 — Estimación rápida

Asigna una talla a cada tarea:

| Talla | Criterio |
|-------|---------|
| S | < 1 hora, fichero único, sin dependencias |
| M | 1-4 horas, 2-5 ficheros, sin cambios de arquitectura |
| L | 4-8 horas, múltiples módulos o nueva abstracción |
| XL | > 8 horas o requiere decisión del Architect primero |

## Nivel 2 — Factores de ajuste

Sube una talla si:
- No hay tests existentes que guíen el cambio
- El área del código no está documentada
- Hay dependencias externas (APIs de terceros, migraciones de BD)

Baja una talla si:
- Hay un patrón idéntico ya implementado en el proyecto
- El Architect ya tomó la decisión de diseño

## Nivel 3 — Estimación de épica completa

1. Suma las tallas individuales (S=1, M=2, L=4, XL=8)
2. Añade 20% de buffer por integración entre tareas
3. Si hay más de 2 tareas XL, recomienda dividir la épica

## Formato de Output

```
Estimación: <nombre del plan>

| Tarea | Agente | Talla | Puntos |
|-------|--------|-------|--------|
| implementar X | coder | M | 2 |
| tests para X | tester | S | 1 |
| componente Y | frontend | L | 4 |

Total: 7 puntos + 20% buffer = ~8.4 puntos
Advertencias: [si las hay]
```
