#!/usr/bin/env bash
# ==============================================================================
# GTA: San Andreas - NVIDIA RTX 4060 Vulkan Execution & Diagnostics Script
# Debian / Kali Linux Environment
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
GAME_DIR="${BASE_DIR}/GTA San Andreas Persian Edition Linux debian"

echo "======================================================================"
echo " GTA: San Andreas - Vulkan RTX 4060 Launcher (Kali Linux)"
echo "======================================================================"

# 1. Force NVIDIA GPU Offloading (PRIME Render Offload)
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json

# 2. DXVK Vulkan Configuration & Real-Time Performance HUD
export DXVK_CONFIG_FILE="${SCRIPT_DIR}/dxvk.conf"
# Displays FPS, Frametime graph, VRAM usage, GPU load percentage, and GPU temp
export DXVK_HUD=fps,frametimes,memory,gputemp,gpu

# 3. NVIDIA Driver Threading & Latency Optimizations
export __GL_THREADED_OPTIMIZATIONS=1
export __GL_YIELD="NOTHING"

echo "[+] Target Game Directory: ${GAME_DIR}"
echo "[+] Target Executable:     ${GAME_DIR}/gta_sa.exe"
echo "[+] Active Vulkan ICD:     ${VK_ICD_FILENAMES}"
echo "[+] DXVK HUD:              ${DXVK_HUD}"

# 4. Check for Wine / Proton Runner
WINE_BIN=""
if command -v wine &>/dev/null; then
    WINE_BIN="wine"
elif command -v wine64 &>/dev/null; then
    WINE_BIN="wine64"
elif [ -f "${HOME}/.steam/steam/steamapps/common/Proton - Experimental/proton" ]; then
    WINE_BIN="${HOME}/.steam/steam/steamapps/common/Proton - Experimental/proton"
fi

if [ -z "${WINE_BIN}" ]; then
    echo "----------------------------------------------------------------------"
    echo "[!] Wine/Proton runner not detected in PATH."
    echo "    To run GTA:SA with Vulkan translation on Debian/Kali, install Wine:"
    echo "    $ sudo dpkg --add-architecture i386"
    echo "    $ sudo apt update && sudo apt install wine wine32:i386 dxvk"
    echo "----------------------------------------------------------------------"
    echo "[*] GPU Diagnostics & Environment ready. To launch manually once Wine is installed:"
    echo "    cd \"${GAME_DIR}\" && wine gta_sa.exe"
    exit 0
fi

echo "[+] Using runner: ${WINE_BIN}"
cd "${GAME_DIR}"
exec "${WINE_BIN}" gta_sa.exe "$@"
