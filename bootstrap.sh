#!/bin/bash
# bootstrap.sh — Descarga e instala el sistema multi-agente desde GitHub
#
# Uso (una sola línea, desde cualquier PC):
#   curl -sSL https://raw.githubusercontent.com/alvarobozser/moichos-agents/main/bootstrap.sh | bash
#   curl -sSL https://raw.githubusercontent.com/alvarobozser/moichos-agents/main/bootstrap.sh | bash -s -- --target /ruta/proyecto

# ── Configuración — actualiza esta URL tras el primer push a GitHub
REPO_URL="https://github.com/alvarobozser/moichos-agents"
BRANCH="main"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

TARGET="$(pwd)"
FORCE=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target|-t) TARGET="$2"; shift 2 ;;
    --force|-f)  FORCE=true; shift ;;
    --help|-h) echo "Uso: bash bootstrap.sh [--target /ruta] [--force]"; exit 0 ;;
    *) shift ;;
  esac
done

echo -e "${BOLD}${BLUE}Sistema Multi-Agente — Bootstrap${NC}"
echo -e "Repo   : ${REPO_URL}"
echo -e "Destino: ${TARGET}"
echo ""

if [[ "$REPO_URL" == *"TU_USUARIO"* ]]; then
  echo -e "${RED}✗ El script no está configurado aún.${NC}"
  echo "  Edita bootstrap.sh y reemplaza alvarobozser/moichos-agents con tu repositorio GitHub."
  exit 1
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "⬇️  Descargando sistema de agentes..."
if command -v git &> /dev/null; then
  git clone --depth 1 --branch "$BRANCH" "$REPO_URL.git" "$TMP_DIR/repo" --quiet
  echo -e "  ${GREEN}✓${NC}  Clonado via git"
else
  curl -sSL "${REPO_URL}/archive/refs/heads/${BRANCH}.zip" -o "$TMP_DIR/repo.zip"
  unzip -q "$TMP_DIR/repo.zip" -d "$TMP_DIR"
  mv "$TMP_DIR"/*-"$BRANCH" "$TMP_DIR/repo"
  echo -e "  ${GREEN}✓${NC}  Descargado via curl"
fi

echo ""
FORCE_FLAG=""
[ "$FORCE" = true ] && FORCE_FLAG="--force"
bash "$TMP_DIR/repo/install.sh" "$TARGET" $FORCE_FLAG
