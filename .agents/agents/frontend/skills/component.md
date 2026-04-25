---
name: component
description: Crear un componente UI nuevo siguiendo el design system del proyecto
version: 1.0.0
agent: frontend
---

## Cuándo usar

Cuando hay que construir un elemento visual nuevo o encapsular UI existente en un componente reutilizable.

## Nivel 1 — Componente mínimo

1. Define primero la interfaz (props / inputs): ¿qué recibe el componente?
2. Implementa el renderizado más simple que cumpla el requisito
3. Aplica los estilos del design system (no inventes estilos nuevos)
4. Añade el atributo de accesibilidad mínimo (ver `accessibility.md`)

## Nivel 2 — Componente con estado

Si el componente maneja estado interno:
- Prefiere estado local si el estado no se comparte con otros componentes
- Usa el gestor de estado del proyecto solo si el dato necesita persistir o compartirse
- Separa lógica (hooks) de presentación (render)

## Nivel 3 — Componente complejo / composable

Para componentes que otros componentes usan como building blocks:
- Sigue el patrón de composición sobre configuración (children / slots / named slots)
- Expone solo las props necesarias; usa valores por defecto para el resto
- Coordina con Tester para snapshot test si el componente tiene variantes visuales importantes

## Checklist

- [ ] Props tienen tipos definidos (TypeScript / PropTypes)
- [ ] Tiene al menos un atributo de accesibilidad (`aria-label`, `role`, etc.)
- [ ] Funciona en mobile y desktop (responsivo)
- [ ] Sin estilos inline que contradigan el design system
- [ ] Nombre del fichero en PascalCase si es React, kebab-case si es Vue/Web Component
