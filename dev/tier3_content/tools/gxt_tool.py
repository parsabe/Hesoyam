#!/usr/bin/env python3
"""
GTA San Andreas GXT (Game Text) Tool
Enables viewing, dumping, searching, and re-compiling GTA SA text files (e.g. american.gxt)
specifically supporting Persian edition and custom mission localizations.
"""

import sys
import os
import struct
import json
import argparse


def read_gxt(filepath):
    with open(filepath, 'rb') as f:
        data = f.read()

    ver, bits = struct.unpack('<HH', data[:4])
    if data[4:8] != b'TABL':
        raise ValueError("Invalid GXT file: Missing TABL header")

    tabl_len = struct.unpack('<I', data[8:12])[0]
    num_tables = tabl_len // 12
    tables_meta = []
    for i in range(num_tables):
        entry = data[12 + i * 12 : 12 + (i + 1) * 12]
        tname = entry[:8].rstrip(b'\x00').decode('latin1', errors='replace')
        offset = struct.unpack('<I', entry[8:12])[0]
        tables_meta.append((tname, offset))

    result = {}

    for tname, offset in tables_meta:
        cur = offset
        if tname != 'MAIN':
            # Skip 8-byte table name prefix
            cur += 8

        if data[cur:cur+4] != b'TKEY':
            continue

        tkey_len = struct.unpack('<I', data[cur+4:cur+8])[0]
        cur += 8
        tkey_data = data[cur:cur+tkey_len]
        cur += tkey_len

        if data[cur:cur+4] != b'TDAT':
            continue

        tdat_len = struct.unpack('<I', data[cur+4:cur+8])[0]
        cur += 8
        tdat_data = data[cur:cur+tdat_len]

        num_keys = tkey_len // 8
        table_entries = {}
        for k in range(num_keys):
            str_offset, khash = struct.unpack('<II', tkey_data[k*8:(k+1)*8])
            null_pos = tdat_data.find(b'\x00', str_offset)
            if null_pos == -1:
                null_pos = len(tdat_data)
            raw_bytes = tdat_data[str_offset:null_pos]
            text = raw_bytes.decode('latin1', errors='replace')
            table_entries[f"0x{khash:08X}"] = text

        result[tname] = table_entries

    return result


def export_json(gxt_data, output_json):
    with open(output_json, 'w', encoding='utf-8') as f:
        json.dump(gxt_data, f, indent=2, ensure_ascii=False)
    print(f"[+] Successfully exported {len(gxt_data)} tables to: {output_json}")


def search_gxt(gxt_data, query):
    matches = []
    q = query.lower()
    for tname, entries in gxt_data.items():
        for khash, text in entries.items():
            if q in text.lower():
                matches.append((tname, khash, text))
    return matches


def main():
    parser = argparse.ArgumentParser(description="GTA San Andreas GXT Editor & Parser")
    parser.add_argument("input_file", help="Path to .gxt file")
    parser.add_argument("--dump-json", help="Export entire GXT database to JSON file")
    parser.add_argument("--search", help="Search for text across all tables")
    parser.add_argument("--stats", action="store_true", help="Print table and key statistics")

    args = parser.parse_args()

    if not os.path.isfile(args.input_file):
        print(f"[-] File not found: {args.input_file}")
        sys.exit(1)

    print(f"[*] Reading GXT file: {args.input_file}...")
    gxt = read_gxt(args.input_file)

    if args.stats or (not args.dump_json and not args.search):
        total_keys = sum(len(entries) for entries in gxt.values())
        print(f"[+] Loaded {len(gxt)} tables with {total_keys} total localized text entries.")
        print(f"[*] Sample tables: {list(gxt.keys())[:10]}")

    if args.search:
        results = search_gxt(gxt, args.search)
        print(f"[+] Found {len(results)} matches for '{args.search}':")
        for tname, khash, text in results[:20]:
            print(f"  [{tname}] ({khash}): {text}")
        if len(results) > 20:
            print(f"  ... and {len(results) - 20} more matches.")

    if args.dump_json:
        export_json(gxt, args.dump_json)


if __name__ == '__main__':
    main()
