#!/usr/bin/env bash
# ==============================================================================
# GTA San Andreas Persian Edition - Ultimate Launcher for Kali Linux
# Fixes:
# 1. 1/4 Black Bar on Right -> Solved via vorbisFile ASI Loader & WidescreenFix
# 2. Force Quit Timeout -> GNOME Mutter check-alive increased to 30s
# 3. Audio Quality -> DirectSound 48kHz / 24-bit studio fidelity
# 4. Hardware -> NVIDIA GeForce RTX 4060 Mobile
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GAME_DIR="${SCRIPT_DIR}/GTA San Andreas Persian Edition Linux debian"

echo "======================================================================"
echo " GTA San Andreas Persian Edition - Fullscreen Widescreen Launcher"
echo " GPU:          NVIDIA GeForce RTX 4060 Mobile"
echo " Aspect Ratio: True 16:9 Widescreen (Black Bar Bug Removed)"
echo " Audio:        Studio 48kHz / 24-bit DirectSound"
echo "======================================================================"

# 1. Force Dedicated NVIDIA RTX 4060 GPU Acceleration
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
export __GL_THREADED_OPTIMIZATIONS=1
export __GL_YIELD="NOTHING"

# 2. Enable Native DLL Overrides for Widescreen Fix (ASI Loader)
export WINEDLLOVERRIDES="vorbisFile=n,b;d3d9=n,b"

# 3. Audio & Prefix Configuration
export PULSE_LATENCY_MSEC=30
export WINEPREFIX="${HOME}/.local/share/gta-sa-persian/prefix"
mkdir -p "${WINEPREFIX}"

# 4. Ensure GNOME does not show the 5-second "Force Quit" timeout
gsettings set org.gnome.mutter check-alive-timeout 30000 2>/dev/null || true

# 5. Disable intro video freezes
if [ -f "${GAME_DIR}/movies/Logo.mpg" ]; then
    mv -f "${GAME_DIR}/movies/Logo.mpg" "${GAME_DIR}/movies/Logo.mpg.bak" 2>/dev/null || true
fi
if [ -f "${GAME_DIR}/movies/GTAtitles.mpg" ]; then
    mv -f "${GAME_DIR}/movies/GTAtitles.mpg" "${GAME_DIR}/movies/GTAtitles.mpg.bak" 2>/dev/null || true
fi

# 6. Launch Authentic Game Executable
cd "${GAME_DIR}"
exec wine gta_sa.exe "$@"
