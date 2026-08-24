#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Helper script to download and compare both variants for a given law ID.
Uses the same optimized downloader and persistent cache as get_htm.py.
"""

import sys
import os
from get_htm import ZakonDownloader, download_single, _load_cache, _save_cache

# Ensure UTF-8 output formatting
for _stream in (sys.stdout, sys.stderr):
    if _stream and hasattr(_stream, 'reconfigure'):
        _stream.reconfigure(encoding='utf-8', errors='replace')


def run_both_variants(doc_id: str = "322-08", output_dir: str = "."):
    print(f"=== Порівняння завантаження обох варіантів для документа: {doc_id} ===")
    downloader = ZakonDownloader()
    cache = _load_cache(output_dir)
    res = download_single(downloader, doc_id, mode="both", output_dir=output_dir, cache=cache)
    _save_cache(output_dir, cache)

    exp = res.get('export', {})
    opd = res.get('opendata', {})

    print("\n" + "=" * 65)
    print("Результати:")
    if exp.get('success'):
        tag = " [ПРОПУЩЕНО]" if exp.get('skipped') else ""
        print(f"1) Варіант 1 (Експорт):  {exp.get('filename')}{tag}")
        print(f"   Шлях: {exp.get('path')} ({exp.get('size'):,} байт)")
    else:
        print(f"1) Варіант 1: Помилка -> {exp.get('error')}")

    if opd.get('success'):
        tag = " [ПРОПУЩЕНО]" if opd.get('skipped') else ""
        print(f"2) Варіант 2 (OpenData): {opd.get('filename')}{tag}")
        print(f"   Шлях: {opd.get('path')} ({opd.get('size'):,} байт)")
    else:
        print(f"2) Варіант 2: Помилка -> {opd.get('error')}")
    print("=" * 65)


if __name__ == '__main__':
    target = " ".join(sys.argv[1:]).strip() if len(sys.argv) > 1 else "322-08"
    run_both_variants(target)

