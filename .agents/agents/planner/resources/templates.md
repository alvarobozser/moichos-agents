# Plantillas del Planner

## Plantilla: Feature estándar

```
Plan: Feature — <nombre>

[ ] [architect] Revisar impacto en arquitectura existente  [S]
[ ] [coder] Implementar lógica de negocio  [M]
[ ] [tester] Tests unitarios  [S]
[ ] [tester] Tests de integración  [M]
[ ] [frontend] Componente UI (si aplica)  [M]
[ ] [docs] Actualizar README / API docs  [S]
[ ] [reviewer] Revisión final  [auto]
```

## Plantilla: Bug fix

```
Plan: Fix — <descripción del bug>

[ ] [coder] Reproducir el bug (añadir test que falle)  [S]
[ ] [coder] Corregir la causa raíz  [M]
[ ] [tester] Verificar que el test ahora pasa  [S]
[ ] [reviewer] Revisión final  [auto]
```

## Plantilla: Refactor

```
Plan: Refactor — <módulo o área>

[ ] [architect] Definir el estado objetivo  [S]
[ ] [tester] Asegurar cobertura existente antes de refactorizar  [M]
[ ] [coder] Aplicar refactor de forma incremental  [L]
[ ] [tester] Verificar que todos los tests siguen pasando  [S]
[ ] [docs] Actualizar documentación técnica afectada  [S]
[ ] [reviewer] Revisión final  [auto]
```

## Plantilla: Nueva API / Endpoint

```
Plan: API — <nombre del endpoint>

[ ] [architect] Diseñar contrato (OpenAPI / tipos)  [M]
[ ] [coder] Implementar endpoint  [M]
[ ] [tester] Tests unitarios del handler  [S]
[ ] [tester] Tests de integración del endpoint  [M]
[ ] [security] Auditar autenticación, autorización e inputs  [M]
[ ] [docs] Documentar en API docs  [S]
[ ] [reviewer] Revisión final  [auto]
```
