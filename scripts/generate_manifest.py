#!/usr/bin/env python3
"""Generate a SHA-256 manifest for an RDOS repository."""

from __future__ import annotations

import argparse
import hashlib
from pathlib import Path

EXCLUDED_DIRS = {
    '.git', '.dart_tool', 'build', '.idea', '.vscode', '__pycache__', '.pytest_cache'
}
EXCLUDED_SUFFIXES = {'.zip', '.pyc', '.log'}


def should_skip(path: Path, root: Path) -> bool:
    relative = path.relative_to(root)
    if any(part in EXCLUDED_DIRS for part in relative.parts):
        return True
    if path.suffix in EXCLUDED_SUFFIXES:
        return True
    return False


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open('rb') as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b''):
            digest.update(chunk)
    return digest.hexdigest()


def build_manifest(root: Path) -> list[str]:
    rows: list[str] = []
    for path in sorted(root.rglob('*')):
        if not path.is_file() or should_skip(path, root):
            continue
        rows.append(f'{sha256_file(path)}  {path.relative_to(root).as_posix()}')
    return rows


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('root', nargs='?', default='.', help='Repository root')
    parser.add_argument('--output', help='Output manifest path')
    args = parser.parse_args()

    root = Path(args.root).resolve()
    rows = build_manifest(root)
    content = '\n'.join(rows) + '\n'

    if args.output:
        output = Path(args.output)
        if not output.is_absolute():
            output = root / output
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(content, encoding='utf-8')
    else:
        print(content, end='')

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
