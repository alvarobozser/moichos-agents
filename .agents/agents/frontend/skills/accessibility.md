---
name: accessibility
description: Garantizar que los componentes cumplen WCAG 2.1 AA para usuarios con discapacidad
version: 1.0.0
agent: frontend
---

## Cuándo usar

En cada componente interactivo o de contenido. La accesibilidad no es opcional.

## Nivel 1 — Checklist mínimo WCAG 2.1 AA

**Semántica**
- [ ] Usa elementos HTML nativos con semántica correcta (`button` para acciones, `a` para navegación, `h1`-`h6` jerárquicamente)
- [ ] Los iconos sin texto visible tienen `aria-label` o `aria-hidden="true"` si son decorativos

**Teclado**
- [ ] Todos los elementos interactivos son alcanzables con Tab
- [ ] El orden de foco sigue el orden visual
- [ ] Hay indicador de foco visible (no `outline: none` sin alternativa)

**Contraste**
- [ ] Contraste mínimo texto normal: 4.5:1
- [ ] Contraste mínimo texto grande (>= 18px normal / >= 14px bold): 3:1

**Formularios**
- [ ] Cada campo tiene un `<label>` asociado (o `aria-label`)
- [ ] Los errores de validación están descritos en texto, no solo con color

## Nivel 2 — Patrones comunes

**Modal / Dialog:**
```html
<div role="dialog" aria-modal="true" aria-labelledby="modal-title">
  <h2 id="modal-title">Título del modal</h2>
  ...
  <button aria-label="Cerrar modal">×</button>
</div>
```

**Botón con icono:**
```html
<button aria-label="Eliminar usuario Alice">
  <svg aria-hidden="true">...</svg>
</button>
```

**Mensaje de error:**
```html
<input aria-describedby="email-error" aria-invalid="true" />
<span id="email-error" role="alert">El email no es válido</span>
```

## Nivel 3 — Herramientas de verificación

- axe DevTools (extensión de navegador) — detección automática
- NVDA / VoiceOver — test manual con lector de pantalla
- Lighthouse (Chrome DevTools) → pestaña Accessibility
- Contraste: https://webaim.org/resources/contrastchecker/

## Referencia

- WCAG 2.1: https://www.w3.org/TR/WCAG21/
- ARIA Patterns: https://www.w3.org/WAI/ARIA/apg/patterns/
