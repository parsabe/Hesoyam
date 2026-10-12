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
