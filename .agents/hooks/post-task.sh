#!/bin/bash
# post-task.sh — Acciones y auditoría tras completar una tarea
# Invocado por el hook Stop de Claude Code

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
CHANGED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

echo "[$TIMESTAMP] post-task: tarea completada"

# ── 1. Escanear ficheros modificados en busca de secrets ──────────────────────
SECRET_PATTERN='(ghp_[a-zA-Z0-9]{36}|sk-ant-api[0-9]+-[a-zA-Z0-9_-]{90,}|sk-[a-zA-Z0-9]{48}|xoxb-[0-9]+-[a-zA-Z0-9-]+|AIza[0-9A-Za-z_-]{35}|AKIA[0-9A-Z]{16}|[Pp]assword\s*[:=]\s*["\x27][^"\x27]{6,}|api[_-]?key\s*[:=]\s*["\x27][^"\x27]{8,}|[Bb]earer\s+[a-zA-Z0-9\-_\.]{20,}|[Ss]ecret\s*[:=]\s*["\x27][^"\x27]{8,})'

MODIFIED_FILES=$(git diff --name-only HEAD 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null)

if [ -n "$MODIFIED_FILES" ]; then
  HITS=$(echo "$MODIFIED_FILES" | while read -r f; do
    [ -f "$f" ] && grep -nEH "$SECRET_PATTERN" "$f" 2>/dev/null
  done)

  if [ -n "$HITS" ]; then
    echo ""
    echo "🚨 ALERTA DE SEGURIDAD: Posibles secrets detectados en ficheros modificados:"
    echo "$HITS" | head -20
    echo ""
    echo "   Revisa estos ficheros ANTES de hacer commit o push."
    echo "   Usa 'git diff' para confirmar qué se va a subir."
  fi
fi

# ── 2. Resumen de cambios ─────────────────────────────────────────────────────
if [ "$CHANGED" -gt "0" ]; then
  echo ""
  echo "📝 Ficheros modificados ($CHANGED):"
  git status --short 2>/dev/null
  echo ""
  echo "💡 Sugerencia: cuando quieras commitear, usa Conventional Commits:"
  echo "   feat(scope): descripción"
  echo "   fix(scope): descripción"
fi

exit 0
