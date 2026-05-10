# GitHub Actions Workflows

Automatizaciones que se ejecutan en eventos de GitHub (PRs, pushes, etc.).

## claude-pr-review.yml

**Revisa automáticamente todas las PRs con Claude.**

### Cómo funciona

```
PR abierta/actualizada
    ↓
GitHub Actions se dispara
    ↓
Descarga el diff de cambios
    ↓
Invoca Claude Sonnet 4.6 API
    ↓
Claude analiza el código
    ↓
Comenta resultados en la PR
```

### Requisitos

1. **API key de Anthropic** (`ANTHROPIC_API_KEY`)
   - Obtén una en: https://console.anthropic.com
   - Plan gratuito: $5/mes (suficiente para pruebas)

### Instalación

1. **Configurar credencial en GitHub:**
   - Ve a `Settings → Secrets and variables → Actions`
   - Haz clic en "New repository secret"
   - Nombre: `ANTHROPIC_API_KEY`
   - Valor: Tu API key
   - Guardar

2. **El workflow está listo** — Se ejecuta automáticamente en cada PR

### Resultado

Verás un comentario como este en cada PR:

```
## 🔍 Claude Code Review

1. Summary of changes (1-2 sentences)
2. Potential issues or improvements
   - Point 1
   - Point 2
3. Questions or concerns

---
Reviewed by Claude Code
```

### Troubleshooting

| Problema | Solución |
|----------|----------|
| "API key invalid" | Verifica que `ANTHROPIC_API_KEY` está en Secrets |
| "No comment appears" | Haz clic en "Checks" en la PR → revisa logs de "Claude PR Review" |
| "Diff too large" | El workflow trunca diffs >100KB automáticamente |
| "Rate limit exceeded" | Consulta https://console.anthropic.com/account/usage |

### Desactivación temporal

```bash
# Renombra para desactivar (no borra)
mv .github/workflows/claude-pr-review.yml .github/workflows/claude-pr-review.yml.disabled

# Renombra para reactivar
mv .github/workflows/claude-pr-review.yml.disabled .github/workflows/claude-pr-review.yml
```

### Costo aproximado

- Sonnet 4.6: ~$0.003 por 1K tokens de entrada
- Promedio por PR: ~200-500 tokens → **$0.0006 a $0.0015 por review**
- Recomendado: revisar el usage en https://console.anthropic.com/account/usage

### Mantener actualizado

El workflow está versionado en `.github/workflows/claude-pr-review.yml`. Para cambios:

1. Edita el archivo directamente
2. Prueba en una rama de feature
3. Commitea a `main` cuando esté validado

O usa la skill reutilizable: [.agents/shared/skills/github-setup.md](.agents/shared/skills/github-setup.md)

### Referencias

- [Skill github-setup](.agents/shared/skills/github-setup.md) — Documentación técnica
- [MANIFEST.md](.agents/MANIFEST.md) — Registro de skills y agentes
- [Convenciones](.agents/shared/resources/conventions.md) — Estándares de código
