# Routing Logic

Árbol de decisión que el orquestador sigue para cada petición.

## Paso 1 — Clasificar la petición

```
¿La petición tiene múltiples requisitos o es ambigua?
  Sí → activar Planner primero
  No → ir a Paso 2

¿Implica decisiones de arquitectura (estructura de carpetas, patrones, tech stack)?
  Sí → activar Architect antes de Coder
  No → ir a Paso 2

¿Es solo una pregunta o explicación (sin cambios en código)?
  Sí → responder directamente sin delegar
  No → ir a Paso 2
```

## Paso 2 — Matriz de activación

| Tipo de tarea | Planner | Architect | Coder | Tester | Security | Frontend | Docs | Reviewer |
|---------------|---------|-----------|-------|--------|----------|----------|------|----------|
| Feature nueva compleja | ✓ | ✓ | ✓ | ✓ | según aplique | según aplique | ✓ | ✓ |
| Feature nueva simple | — | — | ✓ | ✓ | — | — | — | ✓ |
| Bug fix | — | — | ✓ | ✓ | — | — | — | ✓ |
| Refactor | — | ✓ | ✓ | ✓ | — | — | — | ✓ |
| Componente UI | — | — | ✓ | ✓ | — | ✓ | — | ✓ |
| API / endpoint | — | ✓ | ✓ | ✓ | ✓ | — | ✓ | ✓ |
| Auditoría de seguridad | — | — | — | — | ✓ | — | — | ✓ |
| Documentación | — | — | — | — | — | — | ✓ | ✓ |
| Plan / roadmap | ✓ | — | — | — | — | — | — | — |

## Paso 3 — Orden de ejecución

Siempre respeta este orden cuando varios agentes están activos:

```
1. Planner      → produce plan de tareas
2. Architect    → produce decisiones de diseño
3. Coder        → produce código
4. Frontend     → produce componentes UI (en paralelo con Coder si es posible)
5. Tester       → produce tests
6. Security     → produce informe de auditoría
7. Docs         → produce documentación
8. Reviewer     → valida TODO lo anterior (siempre último)
```

## Paso 4 — Manejo del resultado del Reviewer

```
Reviewer devuelve: OK
  └─→ Entregar resultado al usuario

Reviewer devuelve: ❌ [agente-responsable]: [descripción del problema]
  └─→ Reactivar ese agente con el feedback
        └─→ Volver a ejecutar Reviewer
              └─→ Si 2 intentos fallidos → escalar al usuario
```

## Señales de Alerta

Detén la ejecución y consulta al usuario si:
- El Coder solicita eliminar más de 3 ficheros
- La tarea implica cambios en CI/CD, infra o pipelines de despliegue
- Se detectan credenciales o secrets en el código
- Hay conflictos entre los outputs de dos agentes
