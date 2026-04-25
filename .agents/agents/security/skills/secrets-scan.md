---
name: secrets-scan
description: Detectar credenciales, API keys, tokens o secrets expuestos en el código
version: 1.0.0
agent: security
---

## Cuándo usar

Siempre antes de una entrega. También cuando el Reviewer o el Orquestador lo solicita explícitamente.

## Nivel 1 — Patrones a buscar

Busca estos patrones en el código y en el historial de commits:

| Patrón | Ejemplo a detectar |
|--------|--------------------|
| Contraseñas hardcodeadas | `password = "abc123"`, `pwd: "secret"` |
| API keys | `api_key = "sk-..."`, `apiKey: "AIza..."` |
| Tokens JWT | `token = "eyJ..."` (más de 20 chars, base64) |
| Connection strings | `mongodb://user:pass@host`, `postgres://...` |
| Claves privadas | `-----BEGIN RSA PRIVATE KEY-----` |
| AWS / GCP / Azure credentials | `AKIA...`, `ya29....` |

## Nivel 2 — Cómo corregirlo

Si se encuentra un secret:

1. **No comitas el fichero** hasta estar corregido
2. Mueve el valor a una variable de entorno: `process.env.API_KEY`
3. Añade el fichero a `.gitignore` si es un fichero de configuración local
4. Documenta la variable en `.env.example` con un valor de placeholder
5. Si ya se commiteó: el secret debe considerarse comprometido → rotar inmediatamente

## Nivel 3 — Prevención automática

Recomienda al Orquestador configurar:
- `git-secrets` o `gitleaks` como hook pre-commit
- Escaneo en CI con herramientas como TruffleHog o detect-secrets
- Variables de entorno obligatorias documentadas en `.env.example`

## Formato de Output

```
[CRÍTICO] src/config/database.ts:8 — contraseña hardcodeada: DB_PASSWORD = "prod_pass_123"
  Acción: mover a variable de entorno DB_PASSWORD
  Riesgo: si se sube al repositorio, credencial comprometida
```

> Nunca incluyas el valor real del secret en el informe. Usa `***` o `<redacted>`.
