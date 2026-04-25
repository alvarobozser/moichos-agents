# Patrones del Coder

> Este fichero se personaliza por proyecto. Añade aquí los patrones aprobados.

## Estructura por defecto

```
src/
  domain/        ← entidades y lógica de negocio pura (sin dependencias de infra)
  application/   ← casos de uso / servicios de aplicación
  infrastructure/← adaptadores: BD, HTTP, MQ, ficheros
  interfaces/    ← controllers, CLI, API handlers
  shared/        ← tipos, utilidades y constantes transversales
```

## Convenciones de naming

| Concepto | Patrón | Ejemplo |
|----------|--------|---------|
| Clase / tipo | PascalCase | `UserRepository` |
| Función / variable | camelCase | `getUserById` |
| Constante | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Fichero | kebab-case | `user-repository.ts` |
| Test | `*.test.ts` o `*.spec.ts` | `user-service.test.ts` |

## Guard clauses (preferido sobre anidamiento)

```typescript
// MAL
function process(user) {
  if (user) {
    if (user.isActive) {
      // lógica principal
    }
  }
}

// BIEN
function process(user) {
  if (!user) return;
  if (!user.isActive) return;
  // lógica principal
}
```

## Manejo de errores

```typescript
// No silencies excepciones
try {
  await riskyOperation();
} catch (error) {
  logger.error('riskyOperation failed', { error, context });
  throw new DomainError('Descripción del problema', { cause: error });
}
```

## Personalización por proyecto

Añade aquí los patrones específicos del proyecto cuando se establezcan:
- Framework de frontend: _por definir_
- ORM / cliente de BD: _por definir_
- Framework de tests: _por definir_
