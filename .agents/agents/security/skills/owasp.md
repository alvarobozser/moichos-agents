---
name: owasp
description: Auditoría estructurada según OWASP Top 10 (2021)
version: 1.0.0
agent: security
---

## Cuándo usar

Auditoría completa de un módulo o feature con alta exposición a datos sensibles o acceso público.

## Nivel 1 — Las 3 categorías más frecuentes

**A01 — Broken Access Control**
- ¿Los endpoints verifican que el usuario tiene permiso para el recurso específico?
- ¿Hay objetos accesibles por ID sin verificar ownership (IDOR)?

**A02 — Cryptographic Failures**
- ¿Los datos sensibles se transmiten solo por HTTPS?
- ¿Las contraseñas se almacenan con hash fuerte (bcrypt, argon2)?

**A03 — Injection**
- ¿Se usan queries parametrizadas en todas las consultas a BD?
- ¿La entrada del usuario se sanitiza antes de pasarla a comandos del sistema o evaluadores?

## Nivel 2 — Resto del Top 10

**A04 — Insecure Design** — ¿El diseño contempla amenazas (threat modeling)?
**A05 — Security Misconfiguration** — ¿Hay configs por defecto inseguras (CORS *, debug en producción)?
**A06 — Vulnerable Components** — ¿Las dependencias tienen CVEs conocidos?
**A07 — Auth Failures** — ¿Hay protección contra brute force, tokens con expiración correcta?
**A08 — Integrity Failures** — ¿Los objetos deserializados se validan antes de usarse?
**A09 — Logging Failures** — ¿Los eventos de seguridad se loguean sin datos sensibles?
**A10 — SSRF** — ¿Las URLs construidas desde input del usuario están validadas y restringidas?

## Nivel 3 — Recursos de referencia

- OWASP Top 10: https://owasp.org/Top10/
- OWASP Testing Guide: https://owasp.org/www-project-web-security-testing-guide/
- OWASP Cheat Sheet Series: https://cheatsheetseries.owasp.org/

## Formato de Output

Igual que `audit.md` con categoría OWASP añadida:
```
[ALTO] [A01] src/api/posts.ts:22 — acceso al post sin verificar que pertenece al usuario autenticado
```
