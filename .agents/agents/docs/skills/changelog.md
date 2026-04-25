---
name: changelog
description: Mantener el CHANGELOG.md siguiendo el formato Keep a Changelog
version: 1.0.0
agent: docs
---

## Cuándo usar

Al final de cada feature, fix o release. El Orquestador lo activa cuando hay cambios que documentar.

## Nivel 1 — Entrada básica

Añade la entrada en la sección `[Unreleased]` del `CHANGELOG.md`:

```markdown
## [Unreleased]

### Added
- Endpoint POST /users para crear nuevos usuarios

### Fixed
- Error al procesar emails con caracteres especiales (#42)

### Changed
- El campo `name` ahora es obligatorio en POST /users
```

## Nivel 2 — Categorías disponibles

| Categoría | Cuándo usarla |
|-----------|--------------|
| `Added` | Nueva funcionalidad |
| `Changed` | Cambio en funcionalidad existente |
| `Deprecated` | Funcionalidad que se eliminará pronto |
| `Removed` | Funcionalidad eliminada |
| `Fixed` | Corrección de bug |
| `Security` | Corrección de vulnerabilidad |

## Nivel 3 — Crear una release

Cuando el Orquestador indica que hay que publicar una versión:

1. Renombra `[Unreleased]` a `[X.Y.Z] - YYYY-MM-DD`
2. Añade una nueva sección `[Unreleased]` vacía encima
3. Sigue Semantic Versioning: MAJOR.MINOR.PATCH
   - PATCH: solo fixes
   - MINOR: nueva funcionalidad retrocompatible
   - MAJOR: cambio incompatible (breaking change)

## Referencia

- Keep a Changelog: https://keepachangelog.com/
- Semantic Versioning: https://semver.org/
