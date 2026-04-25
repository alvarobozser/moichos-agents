#!/bin/bash
# pre-task.sh — Validaciones antes de ejecutar una tarea de escritura
# Invocado por el hook PreToolUse de Claude Code

TOOL="${1:-unknown}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$TIMESTAMP] pre-task: $TOOL"

# Verificar que estamos dentro de un repo git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "⚠️  AVISO: No estás en un repositorio git. Los cambios no podrán versionarse."
fi

# Advertir si hay cambios sin commitear que podrían perderse
UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [ "$UNCOMMITTED" -gt "5" ]; then
  echo "⚠️  AVISO: Hay $UNCOMMITTED ficheros con cambios sin commitear."
fi

# Verificar que no hay secrets obvios en el working tree (búsqueda rápida)
if git status --porcelain 2>/dev/null | grep -q "\.env$"; then
  echo "⚠️  AVISO: Hay un fichero .env en el working tree. No lo incluyas en el commit."
fi

exit 0
