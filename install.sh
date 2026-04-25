#!/bin/bash
# install.sh — Instala el sistema multi-agente en un proyecto destino
#
# Uso:
#   bash install.sh /ruta/al/proyecto
#   bash install.sh /ruta/al/proyecto --force   # sobreescribir sin preguntar

set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

TARGET="${1:-}"
FORCE=false
[[ "${2:-}" == "--force" ]] && FORCE=true

if [[ -z "$TARGET" || "$TARGET" == "--help" || "$TARGET" == "-h" ]]; then
  echo -e "${BOLD}Sistema Multi-Agente — Instalador${NC}"
  echo ""
  echo "Uso:"
  echo "  bash install.sh /ruta/al/proyecto"
  echo "  bash install.sh /ruta/al/proyecto --force"
  exit 0
fi

SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BOLD}${BLUE}Sistema Multi-Agente — Instalador${NC}"
echo -e "Origen : ${SOURCE}"
echo -e "Destino: ${TARGET}"
echo ""

if [ ! -d "$TARGET" ]; then
  echo -e "${RED}✗ El directorio destino no existe: $TARGET${NC}"
  exit 1
fi

if [ ! -d "$SOURCE/.agents" ]; then
  echo -e "${RED}✗ No se encuentra .agents/ en el origen. ¿Estás ejecutando desde la carpeta correcta?${NC}"
  exit 1
fi

copy_safe() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ "$FORCE" = false ]; then
    echo -e "  ${YELLOW}↷  omitido (ya existe)${NC}: $(basename "$dst")"
  else
    cp -r "$src" "$dst"
    echo -e "  ${GREEN}✓${NC}  $(basename "$dst")"
  fi
}

# ── 1. Carpeta .agents/
echo "📦 Copiando sistema de agentes..."
if [ -d "$TARGET/.agents" ] && [ "$FORCE" = false ]; then
  echo -e "  ${YELLOW}↷  omitido (ya existe)${NC}: .agents/  — usa --force para sobreescribir"
else
  cp -r "$SOURCE/.agents" "$TARGET/"
  COUNT=$(find "$SOURCE/.agents" -type f | wc -l | tr -d ' ')
  echo -e "  ${GREEN}✓${NC}  .agents/  (${COUNT} ficheros)"
fi

# ── 2. Manifests multi-LLM
echo ""
echo "📄 Copiando manifests multi-LLM..."

copy_safe "$SOURCE/AGENTS.md"    "$TARGET/AGENTS.md"
copy_safe "$SOURCE/CLAUDE.md"    "$TARGET/CLAUDE.md"
copy_safe "$SOURCE/opencode.json" "$TARGET/opencode.json"

mkdir -p "$TARGET/.github"
copy_safe "$SOURCE/.github/copilot-instructions.md" "$TARGET/.github/copilot-instructions.md"

# ── 3. Ficheros de configuración opcionales
echo ""
echo "⚙️  Copiando configuración..."
copy_safe "$SOURCE/.env.example" "$TARGET/.env.example"

# ── 4. Resumen
echo ""
echo -e "${GREEN}${BOLD}✓ Instalación completada${NC}"
echo ""
echo -e "${BOLD}Próximos pasos:${NC}"
echo "  1. cp .env.example .env  y rellena tus tokens"
echo "  2. Personaliza AGENTS.md con el nombre y propósito del proyecto"
echo "  3. Edita .agents/shared/resources/conventions.md con las convenciones del proyecto"
echo ""
echo "  Para activar el sistema en tu LLM:"
echo -e "  ${BOLD}\"Carga .agents/MANIFEST.md y actúa como orquestador\"${NC}"
