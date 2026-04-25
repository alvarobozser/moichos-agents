---
name: styling
description: Aplicar estilos coherentes con el design system, responsivos y mantenibles
version: 1.0.0
agent: frontend
---

## Cuándo usar

Al implementar o modificar la apariencia de cualquier componente.

## Nivel 1 — Reglas base

- Usa siempre los tokens del design system (colores, espaciados, tipografías)
- Sin valores mágicos: `padding: 16px` → usa el token equivalente (`spacing-4`, `--space-md`, etc.)
- Mobile-first: diseña el estilo base para móvil, añade breakpoints para pantallas más grandes
- Sin `!important` salvo justificación documentada

## Nivel 2 — Responsividad

```css
/* Mobile first */
.card {
  padding: var(--space-sm);
  flex-direction: column;
}

/* Tablet y superior */
@media (min-width: 768px) {
  .card {
    padding: var(--space-md);
    flex-direction: row;
  }
}
```

Breakpoints estándar (ajustar si el proyecto tiene los suyos):
| Nombre | Mínimo |
|--------|--------|
| sm | 640px |
| md | 768px |
| lg | 1024px |
| xl | 1280px |

## Nivel 3 — Design system no definido en el proyecto

Si el proyecto no tiene design system:
1. Señálalo al Orquestador como deuda técnica
2. Crea un fichero `src/styles/tokens.css` con las variables básicas
3. Usa ese fichero como fuente de verdad desde el primer componente

## Restricciones

- Sin estilos globales que afecten a elementos HTML base (`h1`, `p`, `a`) salvo en el fichero de reset/base global
- Los estilos del componente no deben filtrar fuera de su ámbito (usa CSS Modules, scoped styles o BEM)
