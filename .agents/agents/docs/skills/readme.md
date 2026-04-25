---
name: readme
description: Crear o actualizar el README del proyecto con información útil y actualizada
version: 1.0.0
agent: docs
---

## Cuándo usar

Cuando el proyecto no tiene README, cuando se añade una feature pública relevante, o cuando el Reviewer señala que el README está desactualizado.

## Nivel 1 — README mínimo

Estructura obligatoria:

```markdown
# Nombre del Proyecto

<Una frase describiendo qué hace el proyecto y para quién.>

## Requisitos

- Node.js >= 18 / Python >= 3.11 / ...
- [otras dependencias]

## Instalación

```bash
<comandos de instalación>
```

## Uso rápido

```bash
<ejemplo mínimo funcional>
```

## Variables de entorno

| Variable | Descripción | Requerida |
|----------|-------------|-----------|
| `DATABASE_URL` | URL de conexión a la BD | Sí |
```

## Nivel 2 — Secciones adicionales según el proyecto

Añade solo las que aplican:
- **Arquitectura**: enlace al diagrama o ADR principal
- **Contribución**: cómo enviar un PR
- **Tests**: cómo ejecutar la suite
- **Despliegue**: instrucciones de deploy

## Nivel 3 — README para librerías / APIs públicas

- Incluye ejemplos de código para los casos de uso más comunes
- Documenta todos los parámetros de configuración
- Añade badge de estado de CI y cobertura

## Restricciones

- No documentes el código interno; solo la interfaz pública
- El README no reemplaza la documentación de API (`api-docs.md`)
- Usa el idioma del proyecto; si hay dudas, español para este workspace
