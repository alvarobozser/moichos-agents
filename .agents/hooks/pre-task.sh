#!/bin/bash
# pre-task.sh — Seguridad pre-ejecución
# Invocado por el hook PreToolUse de Claude Code (stdin: JSON payload)
# Exit 2 = bloquear | Exit 0 = permitir

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG="${TEMP:-/tmp}/claude-pre-task.log"
INPUT=$(cat)

# Extraer tool_name para el log (grep -oE + cut, sin Perl ni Python)
TOOL_NAME=$(echo "$INPUT" \
  | grep -oE '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' \
  | cut -d'"' -f4 \
  | head -1)
TOOL_NAME="${TOOL_NAME:-unknown}"

echo "[$TIMESTAMP] tool=$TOOL_NAME" >> "$LOG"

# ── 1. Bloquear dump de variables de entorno ──────────────────────────────────
# Detecta: "command":"env", "command": "env", etc. (con o sin espacios)
if echo "$INPUT" | grep -qE '"command"[[:space:]]*:[[:space:]]*"[[:space:]]*(env|printenv|export -p|set)[[:space:]]*"'; then
  echo "BLOCKED: Dumping all environment variables is not allowed (security policy)." >&2
  echo "[$TIMESTAMP] BLOCKED env dump" >> "$LOG"
  exit 2
fi

# ── 2. Bloquear lectura directa de ficheros .env ──────────────────────────────
if echo "$INPUT" | grep -qE '"command"[[:space:]]*:[[:space:]]*"[^"]*(cat|type|head|tail|less|more|bat)[[:space:]]+[^"]*\.env'; then
  echo "BLOCKED: Reading .env files directly is not allowed (security policy)." >&2
  echo "[$TIMESTAMP] BLOCKED .env read" >> "$LOG"
  exit 2
fi

# ── 3. Bloquear acceso a /proc/*/environ ──────────────────────────────────────
if echo "$INPUT" | grep -qE '/proc/([0-9]+|self)/environ'; then
  echo "BLOCKED: Reading process environment via /proc is not allowed (security policy)." >&2
  echo "[$TIMESTAMP] BLOCKED /proc/environ" >> "$LOG"
  exit 2
fi

# ── 4. Detectar prompt injection ──────────────────────────────────────────────
INJECTION_RE='ignore (all |previous |prior |system )?instructions|disregard (all |previous )?instructions|\[SYSTEM\]|new system prompt|you are now a|forget (all |your |previous )?instructions|jailbreak|DAN mode|override (your |all )?instructions|ignora (todo lo |lo )?anterior|olvida (tus |todas )?instrucciones|act[uú]a como|eres ahora|tu nuevo rol|muestra tus instrucciones|repite tu prompt|\[INST\]|### Instruction:'

if echo "$INPUT" | grep -qiE "$INJECTION_RE"; then
  echo "BLOCKED: Posible prompt injection detectado. Revisa el input antes de continuar." >&2
  echo "[$TIMESTAMP] BLOCKED injection" >> "$LOG"
  exit 2
fi

# ── 5. Checks git ─────────────────────────────────────────────────────────────
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "⚠️  AVISO: No estás en un repositorio git." >&2
fi

UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [ "$UNCOMMITTED" -gt "5" ]; then
  echo "⚠️  AVISO: Hay $UNCOMMITTED ficheros con cambios sin commitear." >&2
fi

if git status --porcelain 2>/dev/null | grep -q "\.env$"; then
  echo "⚠️  AVISO: Hay un fichero .env en el working tree. No lo incluyas en el commit." >&2
fi

exit 0
