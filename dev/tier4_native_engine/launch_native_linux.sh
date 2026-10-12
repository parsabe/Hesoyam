#!/usr/bin/env bash
# ==============================================================================
# GTA: San Andreas (Persian Edition) - 100% Native Linux Runner (No Wine)
# Hardware Acceleration: NVIDIA GeForce RTX 4060 Mobile + Intel i7-12700H
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="${SCRIPT_DIR}/engine"
GAME_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)/GTA San Andreas Persian Edition Linux debian"

echo "======================================================================"
echo " GTA: San Andreas Persian Edition - Native Linux Engine (No Wine)"
echo " Dedicated GPU: NVIDIA GeForce RTX 4060 Mobile"
echo "======================================================================"

# 1. Hardware Offloading: Force NVIDIA Dedicated GPU
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json

# 2. Multithreading & Performance tuning
export __GL_THREADED_OPTIMIZATIONS=1
export __GL_YIELD="NOTHING"

# 3. Verify Configuration
if [ ! -f "${ENGINE_DIR}/config.user.json" ]; then
    echo "[-] Creating config.user.json..."
    echo "{\"game_dir\": \"${GAME_DIR}\"}" > "${ENGINE_DIR}/config.user.json"
fi

echo "[+] Assets Directory: ${GAME_DIR}"
echo "[+] Engine Path:      ${ENGINE_DIR}/SanAndreasUnity.x86_64"
echo "[+] Active GPU:       NVIDIA GeForce RTX 4060 (via PRIME offload)"

cd "${ENGINE_DIR}"
exec ./SanAndreasUnity.x86_64 -force-vulkan "$@"
