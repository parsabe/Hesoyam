#!/usr/bin/env bash
# ==============================================================================
# Native Linux Engine Asset Linking Tool
# Symlinks extracted game data into native engine directories without disk duplication
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
SOURCE_GAME_DIR="${BASE_DIR}/GTA San Andreas Persian Edition Linux debian"
TARGET_ASSET_DIR="${SCRIPT_DIR}/assets"

echo "[*] Setting up Native Engine Assets..."
echo "[+] Source: ${SOURCE_GAME_DIR}"
echo "[+] Target: ${TARGET_ASSET_DIR}"

mkdir -p "${TARGET_ASSET_DIR}"

for folder in anim audio data models movies text ReadMe; do
    if [ -d "${SOURCE_GAME_DIR}/${folder}" ]; then
        ln -sfn "${SOURCE_GAME_DIR}/${folder}" "${TARGET_ASSET_DIR}/${folder}"
        echo "  [OK] Linked ${folder}/"
    fi
done

for cfg in stream.ini; do
    if [ -f "${SOURCE_GAME_DIR}/${cfg}" ]; then
        ln -sfn "${SOURCE_GAME_DIR}/${cfg}" "${TARGET_ASSET_DIR}/${cfg}"
        echo "  [OK] Linked ${cfg}"
    fi
done

echo "[+] Assets linked successfully! No duplicate 6.6GB disk space consumed."
