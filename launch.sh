#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$SCRIPT_DIR/app"

if ! command -v wine &>/dev/null; then
    echo "Erro: Wine não está instalado. Instale o Wine para continuar."
    exit 1
fi

cd "$APP_DIR"
exec wine OemDrv.exe "$@"
