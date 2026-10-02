#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$SCRIPT_DIR/app"
ASSETS_DIR="$SCRIPT_DIR/assets"
ICON_DEST="$HOME/.local/share/icons"
DESKTOP_DEST="$HOME/.local/share/applications"

echo "=========================================================="
echo "  Instalação do Software Redragon Rind Pro (M813-RGB-PRO) "
echo "=========================================================="

# 1. Verificar dependências
if ! command -v wine &>/dev/null; then
    echo "[-] Erro: 'wine' não encontrado no sistema. Por favor, instale o Wine primeiro."
    exit 1
fi
echo "[+] Wine detectado: $(wine --version)"

# 2. Configurar o WineBus para permitir acesso direto HID (hidraw)
echo "[*] Configurando o registro do WineBus para acesso direto ao hardware..."
wine reg add "HKLM\\System\\CurrentControlSet\\Services\\WineBus" /v "DisableHidraw" /t REG_DWORD /d 0 /f >/dev/null 2>&1 || true
wine reg add "HKLM\\System\\CurrentControlSet\\Services\\WineBus" /v "DisableInput" /t REG_DWORD /d 1 /f >/dev/null 2>&1 || true
wine reg add "HKLM\\System\\CurrentControlSet\\Services\\WineBus" /v "EnableHidraw" /t REG_MULTI_SZ /d "25A7:FA7C" /f >/dev/null 2>&1 || true

# Configurar subchaves do dispositivo (VID 25a7 / PIDs fa7b, fa7c)
wine reg add "HKLM\\System\\CurrentControlSet\\Services\\WineBus\\Devices\\25a7" /v "Hidraw" /t REG_DWORD /d 1 /f >/dev/null 2>&1 || true
wine reg add "HKLM\\System\\CurrentControlSet\\Services\\WineBus\\Devices\\25a7/fa7c" /v "Hidraw" /t REG_DWORD /d 1 /f >/dev/null 2>&1 || true
wine reg add "HKLM\\System\\CurrentControlSet\\Services\\WineBus\\Devices\\25a7/fa7b" /v "Hidraw" /t REG_DWORD /d 1 /f >/dev/null 2>&1 || true

# Reiniciar o subsistema Wine
wineserver -k >/dev/null 2>&1 || true
echo "[+] Registro do Wine configurado com sucesso!"

# 3. Permissões e script executável
chmod +x "$SCRIPT_DIR/launch.sh"

# 4. Instalar ícone
mkdir -p "$ICON_DEST"
if [ -f "$ASSETS_DIR/redragon-m813.png" ]; then
    cp "$ASSETS_DIR/redragon-m813.png" "$ICON_DEST/redragon-m813.png"
    echo "[+] Ícone copiado para $ICON_DEST/redragon-m813.png"
fi

# 5. Criar entrada .desktop no menu de aplicativos
mkdir -p "$DESKTOP_DEST"
cat > "$DESKTOP_DEST/redragon-m813.desktop" <<EOF
[Desktop Entry]
Name=Redragon M813 RGB-PRO
Comment=Software de configuração do mouse Redragon Rind Pro M813
Exec=$SCRIPT_DIR/launch.sh
Icon=$ICON_DEST/redragon-m813.png
Terminal=false
Type=Application
Categories=Settings;HardwareSettings;Utility;
StartupWMClass=oemdrv.exe
EOF

chmod +x "$DESKTOP_DEST/redragon-m813.desktop"
echo "[+] Atalho criado em $DESKTOP_DEST/redragon-m813.desktop"

# Atualizar caches do sistema
update-desktop-database "$DESKTOP_DEST" >/dev/null 2>&1 || true
kbuildsycoca6 >/dev/null 2>&1 || true

echo "=========================================================="
echo "  Instalação concluída com sucesso!                      "
echo "  Você pode iniciar o software pelo menu de aplicativos  "
echo "  ou executando: ./launch.sh                             "
echo "=========================================================="
