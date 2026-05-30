#!/usr/bin/env python3
"""Package an RDOS repository without self-including generated ZIP artifacts."""

from __future__ import annotations

import argparse
import zipfile
from pathlib import Path

EXCLUDED_DIRS = {'.git', '.dart_tool', 'build', '.idea', '.vscode', '__pycache__', '.pytest_cache'}
EXCLUDED_SUFFIXES = {'.zip', '.pyc', '.log'}


def should_skip(path: Path, root: Path, output: Path) -> bool:
    try:
        if path.resolve() == output.resolve():
            return True
    except FileNotFoundError:
        pass
    relative = path.relative_to(root)
    if any(part in EXCLUDED_DIRS for part in relative.parts):
        return True
    if path.suffix in EXCLUDED_SUFFIXES:
        return True
    return False


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('root', nargs='?', default='.')
    parser.add_argument('--output', required=True)
    parser.add_argument('--strict', action='store_true')
    args = parser.parse_args()

    root = Path(args.root).resolve()
    output = Path(args.output).resolve()
    output.parent.mkdir(parents=True, exist_ok=True)

    if args.strict and root in output.parents:
        raise SystemExit('Strict mode refused: output ZIP must be outside repository root.')

    with zipfile.ZipFile(output, 'w', compression=zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(root.rglob('*')):
            if not path.is_file() or should_skip(path, root, output):
                continue
            archive.write(path, path.relative_to(root).as_posix())

    print(output)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
