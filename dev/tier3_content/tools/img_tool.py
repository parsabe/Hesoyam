#!/usr/bin/env python3
"""
GTA San Andreas IMG v2 Archive Tool
Lists, searches, and extracts 3D assets (.dff models, .txd textures, .col collision)
from gta3.img, player.img, cuts.img, and gta_int.img.
"""

import sys
import os
import struct
import argparse

SECTOR_SIZE = 2048


def read_img_directory(filepath):
    with open(filepath, 'rb') as f:
        header = f.read(8)
        if header[:4] != b'VER2':
            raise ValueError(f"Unsupported IMG version (Expected VER2, got {header[:4]})")
        num_entries = struct.unpack('<I', header[4:8])[0]

        entries = []
        for _ in range(num_entries):
            entry_bytes = f.read(32)
            if len(entry_bytes) < 32:
                break
            offset_sectors, size_sectors, _ = struct.unpack('<IHH', entry_bytes[:8])
            name = entry_bytes[8:].split(b'\x00')[0].decode('latin1', errors='replace')
            entries.append({
                'name': name,
                'offset': offset_sectors * SECTOR_SIZE,
                'size': size_sectors * SECTOR_SIZE,
                'sectors': size_sectors
            })
    return entries


def extract_entry(img_path, entry, output_path):
    with open(img_path, 'rb') as f_in:
        f_in.seek(entry['offset'])
        data = f_in.read(entry['size'])
    with open(output_path, 'wb') as f_out:
        f_out.write(data)
    print(f"[+] Extracted: {entry['name']} -> {output_path} ({entry['size']} bytes)")


def main():
    parser = argparse.ArgumentParser(description="GTA San Andreas IMG v2 Tool")
    parser.add_argument("img_file", help="Path to .img archive (e.g. gta3.img)")
    parser.add_argument("--list", action="store_true", help="List all files in archive")
    parser.add_argument("--search", help="Search for assets by name (e.g. 'infernus', 'cheetah', 'police')")
    parser.add_argument("--extract", help="Extract specific asset by name")
    parser.add_argument("--outdir", default=".", help="Output directory for extraction")

    args = parser.parse_args()

    if not os.path.isfile(args.img_file):
        print(f"[-] Archive not found: {args.img_file}")
        sys.exit(1)

    entries = read_img_directory(args.img_file)
    print(f"[*] Archive: {args.img_file} | Total Items: {len(entries)}")

    if args.list:
        for e in entries:
            print(f"  {e['name']:<24} {e['size']:>10} bytes (Offset: 0x{e['offset']:08X})")

    if args.search:
        q = args.search.lower()
        matches = [e for e in entries if q in e['name'].lower()]
        print(f"[+] Found {len(matches)} matches for '{args.search}':")
        for m in matches:
            print(f"  {m['name']:<24} {m['size']:>10} bytes")

    if args.extract:
        target = [e for e in entries if e['name'].lower() == args.extract.lower()]
        if not target:
            print(f"[-] Asset '{args.extract}' not found in archive.")
            sys.exit(1)
        os.makedirs(args.outdir, exist_ok=True)
        out_file = os.path.join(args.outdir, target[0]['name'])
        extract_entry(args.img_file, target[0], out_file)


if __name__ == '__main__':
    main()
