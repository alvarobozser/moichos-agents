# Convenciones del Proyecto

> Fuente de verdad para todos los agentes. Si una convención cambia, actualiza este fichero.

## Idioma

- Código: inglés (nombres de variables, funciones, clases)
- Documentación y comentarios: español (salvo que el proyecto tenga ya documentación en inglés)
- Commits: inglés (Conventional Commits)

## Nomenclatura

| Elemento | Patrón | Ejemplo |
|----------|--------|---------|
| Clase / Tipo / Interfaz | PascalCase | `UserRepository`, `CreateUserDto` |
| Función / variable | camelCase | `getUserById`, `isActive` |
| Constante | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Fichero | kebab-case | `user-repository.ts` |
| Carpeta | kebab-case | `user-management/` |
| Test | `*.test.ts` / `*.spec.ts` | `user-service.test.ts` |
| Componente React | PascalCase.tsx | `UserCard.tsx` |

## Estructura de carpetas (hexagonal por defecto)

```
src/
  domain/         ← entidades, interfaces de repositorio, lógica de negocio pura
  application/    ← casos de uso / servicios de aplicación
  infrastructure/ ← implementaciones: BD, HTTP, MQ, ficheros
  interfaces/     ← controllers, API handlers, CLI
  shared/         ← tipos, utilidades y constantes transversales
tests/
  unit/
  integration/
docs/
  adr/            ← Architecture Decision Records
  architecture/   ← diagramas y documentos de arquitectura
```

## Reglas de código

- Una función = una responsabilidad; guía: máx. ~20 líneas
- Máx. 3-4 parámetros; si necesitas más, usa un objeto/DTO
- Guard clauses en lugar de anidamiento profundo
- Inmutabilidad por defecto donde sea posible
- Sin magic numbers: constantes con nombre
- Sin código comentado sin justificación

## Manejo de errores

- Nunca `catch (e) {}` vacío
- Captura excepciones específicas, no `Exception` genérica
- Loguea con contexto: qué operación falló y con qué datos
- APIs REST: errores en formato RFC 7807 (Problem Details)

## Tests

- Patrón AAA: Arrange / Act / Assert
- Nombre: `should <comportamiento> when <condición>`
- Tests independientes entre sí (sin estado compartido)
- Cobertura mínima objetivo: 80% en lógica de negocio

## Seguridad

- Nunca hardcodear credenciales, API keys o secrets
- Variables de entorno documentadas en `.env.example`
- Validar toda entrada externa antes de usarla
- Mínimo privilegio en permisos y roles

## Commits

- Formato Conventional Commits (ver `shared/skills/git.md`)
- Commits atómicos
- Sin binarios, `.env` ni ficheros generados

## Arquitectura

- Hexagonal: el dominio no importa infraestructura
- Depende de abstracciones, no de implementaciones concretas
- Contratos explícitos entre módulos (interfaces, OpenAPI, Protobuf)
- Toda decisión de arquitectura significativa → ADR en `docs/adr/`

## Referencias

| Tema | Recurso |
|------|---------|
| Conventional Commits | https://conventionalcommits.org |
| Keep a Changelog | https://keepachangelog.com |
| OWASP Top 10 | https://owasp.org/Top10 |
| WCAG 2.1 | https://www.w3.org/TR/WCAG21 |
| OpenAPI | https://swagger.io/specification |
| Twelve-Factor | https://12factor.net |
