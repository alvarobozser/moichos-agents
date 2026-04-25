---
name: unit-test
description: Escribir tests unitarios para lógica de negocio usando el patrón AAA
version: 1.0.0
agent: tester
---

## Cuándo usar

Después de que el Coder implementa nueva lógica de negocio, o cuando el Reviewer señala que falta cobertura unitaria.

## Nivel 1 — Test mínimo

1. Identifica la unidad a testear (función o clase)
2. Escribe un test por cada caso de comportamiento, no por cada línea de código
3. Sigue el patrón AAA: **Arrange** (preparar datos), **Act** (ejecutar), **Assert** (verificar resultado)
4. Nombre del test en formato: `should <comportamiento esperado> when <condición>`

## Nivel 2 — Casos que siempre debes cubrir

- El camino feliz (input válido → output esperado)
- Input vacío o nulo
- Límites (valor mínimo, valor máximo)
- Caso de error / excepción esperada

## Nivel 3 — Tests de comportamiento asíncrono

- Usa `async/await` o las utilidades de tu framework para manejar promesas
- Testea el caso de rechazo (error), no solo la resolución
- No uses `setTimeout` en tests; usa mocks de tiempo si es necesario

## Checklist

- [ ] Test falla antes de que el código esté implementado (si es TDD)
- [ ] Test pasa después de la implementación
- [ ] Tests son independientes: no dependen del orden de ejecución
- [ ] No hay lógica de negocio dentro del test

## Ejemplo de estructura

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should return created user when input is valid', async () => {
      // Arrange
      const input = { name: 'Alice', email: 'alice@example.com' };
      // Act
      const result = await userService.createUser(input);
      // Assert
      expect(result.id).toBeDefined();
      expect(result.name).toBe('Alice');
    });

    it('should throw ValidationError when email is missing', async () => {
      // Arrange
      const input = { name: 'Alice' };
      // Act & Assert
      await expect(userService.createUser(input)).rejects.toThrow(ValidationError);
    });
  });
});
```
