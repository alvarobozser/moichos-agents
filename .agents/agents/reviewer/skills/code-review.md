---
name: code-review
description: Revisar calidad del código según criterios objetivos y predefinidos
version: 1.0.0
agent: reviewer
---

## Cuándo usar

Siempre. Es la primera skill del Reviewer, que la aplica a todo el código del flujo.

## Nivel 1 — Checklist básico (siempre se aplica)

**Corrección**
- [ ] El código hace lo que el requisito pide
- [ ] No hay casos borde sin tratar
- [ ] Los tests cubren el camino feliz y al menos un caso de error

**Legibilidad**
- [ ] Nombres de variables, funciones y clases son descriptivos
- [ ] Sin magic numbers: constantes con nombre
- [ ] Sin código comentado sin justificación

**Seguridad**
- [ ] Sin credenciales hardcodeadas
- [ ] Entrada del usuario validada

**Convenciones**
- [ ] Sigue las convenciones de `shared/resources/conventions.md`
- [ ] Commits en formato Conventional Commits

## Nivel 2 — Criterios adicionales para código complejo

- Funciones de más de 20 líneas: ¿se puede extraer responsabilidad?
- Más de 3 niveles de anidamiento: ¿se puede refactorizar con guard clauses?
- Dependencias directas de infraestructura en el dominio: violación de arquitectura hexagonal

## Nivel 3 — Lo que NO es motivo de rechazo

El Reviewer no rechaza por:
- Preferencias de estilo subjetivas no definidas en las convenciones
- Optimizaciones prematuras
- Código que "podría mejorarse" sin razón objetiva

## Criterios de Bloqueo (rechazo obligatorio)

| Severidad | Criterio |
|-----------|---------|
| Bloquea entrega | Secret expuesto, test fallido, comportamiento incorrecto |
| Bloquea entrega | Violación de arquitectura hexagonal en capa de dominio |
| Recomendar mejora | Cobertura < 60% en lógica de negocio nueva |
| Informativo | Oportunidad de refactor sin impacto funcional |
