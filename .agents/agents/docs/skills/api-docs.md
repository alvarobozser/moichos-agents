---
name: api-docs
description: Documentar endpoints REST o interfaces públicas en formato OpenAPI o Markdown
version: 1.0.0
agent: docs
---

## Cuándo usar

Después de que el Coder implementa un endpoint nuevo o modifica la interfaz pública de un módulo.

## Nivel 1 — Documentación mínima por endpoint

Para cada endpoint REST, documenta:

```markdown
### POST /users

Crea un nuevo usuario.

**Body** (application/json):
| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| name | string | Sí | Nombre completo |
| email | string | Sí | Email único |

**Respuestas**:
| Código | Descripción |
|--------|-------------|
| 201 | Usuario creado. Body: `{ id, name, email, createdAt }` |
| 400 | Validación fallida. Body: `{ errors: [...] }` |
| 409 | Email ya registrado |
```

## Nivel 2 — OpenAPI / Swagger

Si el proyecto ya usa OpenAPI, añade la definición al fichero `openapi.yaml` o `openapi.json`:

```yaml
/users:
  post:
    summary: Crear usuario
    requestBody:
      required: true
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/CreateUserDto'
    responses:
      '201':
        description: Usuario creado
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UserDto'
```

## Nivel 3 — Documentación de cambios incompatibles

Si el cambio rompe la API existente (breaking change):
- Documenta la versión anterior y la nueva
- Añade una nota de migración
- Activa al Reviewer para validar el impacto

## Restricciones

- Documenta solo el contrato público; no la implementación interna
- Mantén los ejemplos sincronizados con el código real
