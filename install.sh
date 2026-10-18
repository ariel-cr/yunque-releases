#!/usr/bin/env bash
set -euo pipefail

REPO="ariel-cr/yunque-releases"
VERSION="${YUNQUE_VERSION:-latest}"
INSTALL_DIR="${YUNQUE_INSTALL_DIR:-$HOME/.local/bin}"

say() { printf '%s\n' "$*"; }
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Linux) PLATFORM="linux" ;;
  Darwin) PLATFORM="macos" ;;
  *) fail "Sistema no soportado: $OS. En Windows usa install.ps1." ;;
esac

case "$ARCH" in
  x86_64|amd64) CPU="x86_64" ;;
  arm64|aarch64) CPU="arm64" ;;
  *) fail "Arquitectura no soportada: $ARCH" ;;
esac

if [ "$PLATFORM" = "linux" ]; then
  [ "$CPU" = "x86_64" ] || fail "No hay binario Linux para $CPU en esta publicación."
  ASSET="yunque-linux-x86_64"
else
  [ "$CPU" = "arm64" ] && ASSET="yunque-macos-arm64" || ASSET="yunque-macos-x86_64"
fi

if [ "$VERSION" = "latest" ]; then
  URL="https://github.com/$REPO/releases/latest/download/$ASSET"
else
  URL="https://github.com/$REPO/releases/download/$VERSION/$ASSET"
fi

say "Instalando Yunque..."
TMP="$(mktemp)"
REPORT="$(mktemp)"
trap 'rm -f "$TMP" "$REPORT"' EXIT
curl -fsSL --retry 3 --retry-delay 2 -o "$TMP" "$URL" || fail "No se pudo descargar Yunque."

mkdir -p "$INSTALL_DIR"
INSTALL_DIR="$(cd "$INSTALL_DIR" && pwd -P)"
mv "$TMP" "$INSTALL_DIR/yunque"
chmod +x "$INSTALL_DIR/yunque"

BINARY_VERSION="$("$INSTALL_DIR/yunque" --version 2>&1)" || fail "$BINARY_VERSION"
if ! "$INSTALL_DIR/yunque" install-agents --binary "$INSTALL_DIR/yunque" >"$REPORT" 2>&1; then
  cat "$REPORT" >&2
  fail "No se pudieron registrar todos los subagentes. El binario está en $INSTALL_DIR/yunque."
fi

say ""
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then printf '\033[38;5;208m'; fi
cat <<'BANNER'
 __   ___   _ _   _  ___  _   _ _____
 \ \ / / | | | \ | |/ _ \| | | | ____|
  \ V /| | | |  \| | | | | | | |  _|
   | | | |_| | |\  | |_| | |_| | |___
   |_|  \___/|_| \_|\__\_\\___/|_____|
BANNER
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then printf '\033[0m'; fi
say ""
say "Yunque has been installed."
say "Versión: ${BINARY_VERSION#yunque }"
say "Ubicación: $INSTALL_DIR/yunque"
case "$(cat "$REPORT")" in
  *'"hosts": {}'*) say "No se detectaron anfitriones. Ejecuta yunque install-agents cuando instales uno." ;;
  *) say "Reinicia tu agente y abre tu proyecto Godot." ;;
esac
case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *) say ""
     say "Añade a tu perfil de shell:"
     say "  export PATH=\"$INSTALL_DIR:\$PATH\"" ;;
esac
