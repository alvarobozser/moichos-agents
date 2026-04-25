---
name: adr
description: Documentar una decisión de arquitectura significativa como Architecture Decision Record
version: 1.0.0
agent: architect
---

## Cuándo usar

Cada vez que se toma una decisión de arquitectura que:
- Es difícil de revertir
- Afecta a múltiples módulos o equipos
- Podría ser cuestionada en el futuro

## Nivel 1 — ADR mínimo

Crea el fichero en `docs/adr/NNNN-<nombre-en-kebab>.md`:

```markdown
# NNNN — <Título de la decisión>

**Estado**: Aceptado | Propuesto | Deprecado | Reemplazado por ADR-XXXX
**Fecha**: YYYY-MM-DD

## Contexto
<Por qué esta decisión es necesaria. Qué problema resuelve.>

## Decisión
<Qué se decidió, de forma concisa.>

## Consecuencias
<Qué mejora, qué empeora, qué queda pendiente.>
```

## Nivel 2 — ADR con alternativas

Cuando hay debate o varias opciones viables, añade:

```markdown
## Alternativas consideradas

### Opción A: <nombre>
- Pros: ...
- Contras: ...

### Opción B: <nombre>
- Pros: ...
- Contras: ...

## Justificación de la elección
<Por qué se eligió esta opción sobre las demás.>
```

## Nivel 3 — ADR de reemplazo

Cuando una decisión anterior queda obsoleta:
- Cambia el estado del ADR original a `Reemplazado por ADR-XXXX`
- Crea un ADR nuevo con estado `Aceptado`
- El nuevo ADR referencia al anterior en la sección de contexto

## Numeración

El número `NNNN` es secuencial. Consulta `docs/adr/` para el último número usado.
