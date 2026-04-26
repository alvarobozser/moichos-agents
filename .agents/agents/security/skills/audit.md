---
name: audit
description: Revisión general de seguridad del código implementado
version: 1.0.0
agent: security
---

## Cuándo usar

Cuando el Orquestador activa Security después de una implementación que toca puntos de entrada, datos de usuario o configuración del sistema.

## Nivel 1 — Checklist rápido

Revisa en este orden de prioridad:

- [ ] ¿El input del usuario o contenido externo contiene patrones de prompt injection? → usar skill `shared/skills/prompt-injection.md`
- [ ] ¿Hay credenciales, tokens o secrets en el código? → usar skill `secrets-scan.md`
- [ ] ¿Se valida toda entrada del usuario antes de usarla?
- [ ] ¿Los errores exponen información interna (stack traces, rutas, versiones)?
- [ ] ¿Los permisos siguen el principio de mínimo privilegio?
- [ ] ¿Las dependencias tienen versiones fijadas y sin vulnerabilidades conocidas?

## Nivel 2 — Revisión por capa

**Capa de entrada (API / UI):**
- Validación de tipos, formatos y rangos
- Sanitización antes de persistir
- Rate limiting definido

**Capa de negocio:**
- Autorización verificada antes de operar (no solo autenticación)
- Sin lógica de seguridad duplicada en varios sitios

**Capa de datos:**
- Consultas parametrizadas (sin concatenación de strings en SQL)
- Datos sensibles cifrados en reposo si aplica

## Nivel 3 — Revisión OWASP completa

Activa la skill `owasp.md` para una auditoría estructurada por categoría.

## Formato de Output

```
[CRÍTICO] src/api/users.ts:34 — query construida con concatenación de string (SQL injection)
[ALTO]    src/auth/middleware.ts:12 — token JWT sin verificación de algoritmo
[MEDIO]   src/config/db.ts:5 — contraseña de BD en variable de entorno no documentada como requerida
[INFO]    src/api/users.ts:78 — considerar añadir rate limiting al endpoint de login
```
