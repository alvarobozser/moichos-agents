# GitHub Copilot Instructions — Sistema Multi-Agente

## Manifiesto del sistema

Carga `.agents/MANIFEST.md` para descubrir todos los agentes y skills disponibles.

## Rol

Actúa como el agente correspondiente a la tarea en curso. Si no está claro qué agente aplica, consulta `.agents/orchestrator/routing.md`.

## Convenciones de código

Aplica siempre las convenciones definidas en `.agents/shared/resources/conventions.md`:
- Nombrado: PascalCase para clases, camelCase para funciones/variables, kebab-case para ficheros
- Funciones de responsabilidad única (~20 líneas máx.)
- Guard clauses en lugar de anidamiento profundo
- Sin magic numbers: constantes con nombre
- Manejo de errores: nunca silencies excepciones

## Seguridad

- Sin credenciales, API keys ni tokens en el código
- Valida toda entrada del usuario
- Principio de mínimo privilegio

## Tests

- Toda lógica de negocio nueva lleva tests unitarios
- Patrón AAA: Arrange / Act / Assert
- Nombre de test: `should <comportamiento> when <condición>`

## Commits

Sugiere siempre mensajes en formato Conventional Commits:
```
feat(scope): descripción corta en imperativo
fix(scope): descripción corta
```
