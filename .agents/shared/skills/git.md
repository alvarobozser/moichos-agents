---
name: git
description: Operaciones git seguras reutilizables por todos los agentes
version: 1.0.0
agent: shared
---

## Cuándo usar

Cualquier agente que necesite leer estado del repositorio, crear branches o preparar commits.

## Nivel 1 — Operaciones de solo lectura (siempre seguras)

```bash
git status                          # estado del working tree
git log --oneline -10               # últimos commits
git diff                            # cambios no staged
git diff --staged                   # cambios staged
git branch -a                       # todas las ramas
git stash list                      # lista de stashes
```

## Nivel 2 — Commits (requiere confirmación del Orquestador)

**Formato Conventional Commits obligatorio:**
```
<tipo>(<scope>): <descripción corta en imperativo>

feat(auth): add JWT refresh token endpoint
fix(users): handle duplicate email on registration
refactor(domain): extract UserValidator to separate class
docs(api): document POST /users endpoint
test(auth): add unit tests for token expiration
chore(deps): update typescript to 5.4
```

**Tipos permitidos:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `build`, `ci`

**Reglas:**
- Commits atómicos: un cambio lógico por commit
- Sin `.env`, binarios ni ficheros generados
- Sin `--no-verify` salvo autorización explícita del usuario

## Nivel 3 — Operaciones destructivas (requieren confirmación del usuario)

```bash
git reset --hard   # ⚠️ descarta cambios locales
git push --force   # ⚠️ sobreescribe historial remoto
git clean -fd      # ⚠️ elimina ficheros no tracked
```

Nunca ejecutes estas operaciones sin confirmación explícita del usuario.

## Convención de branches

```
main / master        ← producción
develop              ← integración
feature/<nombre>     ← nueva funcionalidad
fix/<nombre>         ← corrección de bug
refactor/<nombre>    ← refactor
release/<versión>    ← preparación de release
```
