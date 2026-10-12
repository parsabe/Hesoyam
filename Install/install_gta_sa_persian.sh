#!/usr/bin/env bash
# ==============================================================================
# GTA San Andreas Persian Edition - 1-Click System Installer for Kali / Debian
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEB_PACKAGE="${SCRIPT_DIR}/gta-sa-persian-edition_1.1.0_all.deb"

echo "======================================================================"
echo " Installing GTA San Andreas Persian Edition for Debian / Kali Linux"
echo "======================================================================"

if [ "$(id -u)" -ne 0 ]; then
    echo "[!] Please run this installer with sudo: sudo ./install_gta_sa_persian.sh"
    exit 1
fi

echo "[1/3] Enabling 32-bit architecture..."
dpkg --add-architecture i386

# Auto-detect and link extracted game directory to /opt/gta-sa-persian
REPO_DIR="$(dirname "${SCRIPT_DIR}")"
GAME_CANDIDATE=""
if [ -d "${REPO_DIR}/GTA San Andreas Persian Edition Linux debian" ]; then
    GAME_CANDIDATE="${REPO_DIR}/GTA San Andreas Persian Edition Linux debian"
elif [ -d "${REPO_DIR}/kernel" ]; then
    GAME_CANDIDATE="${REPO_DIR}/kernel"
elif [ -d "${SCRIPT_DIR}/GTA San Andreas Persian Edition Linux debian" ]; then
    GAME_CANDIDATE="${SCRIPT_DIR}/GTA San Andreas Persian Edition Linux debian"
fi

if [ -n "${GAME_CANDIDATE}" ]; then
    echo "[*] Setting up system link: /opt/gta-sa-persian -> ${GAME_CANDIDATE}"
    ln -sfn "${GAME_CANDIDATE}" /opt/gta-sa-persian
fi

echo "[2/3] Installing Debian Package and dependencies..."
apt update -qq
apt install -y "${DEB_PACKAGE}"

echo "[3/3] Optimizing Window Manager & Audio Settings..."
if [ -n "${SUDO_USER}" ]; then
    sudo -u "${SUDO_USER}" gsettings set org.gnome.mutter check-alive-timeout 30000 2>/dev/null || true
fi

echo "======================================================================"
echo "[+] SUCCESS: GTA San Andreas Persian Edition is installed!"
echo "    - Launch command:  gta-sa-persian"
echo "    - Menu entry:      Applications -> Games -> GTA San Andreas Persian Edition"
echo "======================================================================"
