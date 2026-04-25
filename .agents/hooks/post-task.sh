#!/bin/bash
# post-task.sh — Acciones tras completar una tarea
# Invocado por el hook Stop de Claude Code

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
CHANGED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

echo "[$TIMESTAMP] post-task: tarea completada"

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
