#!/usr/bin/env python3
"""Small RDOS repository audit for structure, secrets and generated artifacts."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

REQUIRED_PATHS = [
    'README.md',
    'pubspec.yaml',
    'analysis_options.yaml',
    '.gitignore',
    'LICENSE',
    'lib/main.dart',
    'lib/app.dart',
    'test/distance_service_test.dart',
    'docs/RDOS_MANIFEST.md',
    'docs/QUALITY_GATE.md',
    'scripts/generate_manifest.py',
    'scripts/package_release.py',
]

FORBIDDEN_DIRS = ['build', '.dart_tool', '__pycache__', '.pytest_cache']
SECRET_PATTERNS = [
    re.compile(r'gh[pousr]_[A-Za-z0-9_]{20,}'),
    re.compile(r'AKIA[0-9A-Z]{16}'),
    re.compile(r'-----BEGIN (RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----'),
    re.compile(r'(?i)(password|token|secret|api_key)\s*=\s*["\'][^"\']{8,}["\']'),
]
SKELETON_MARKERS = ['TODO' + '_FILL', 'PLACEHOLDER' + '_ONLY', 'CHANGEME' + '_NOW']
TEXT_SUFFIXES = {'.md', '.yaml', '.yml', '.dart', '.py', '.txt', '.json', '.gitignore'}


def is_text_file(path: Path) -> bool:
    return path.name == '.gitignore' or path.suffix in TEXT_SUFFIXES


def audit(root: Path) -> tuple[int, list[str], list[str]]:
    errors: list[str] = []
    warnings: list[str] = []

    for relative in REQUIRED_PATHS:
        if not (root / relative).exists():
            errors.append(f'Missing required path: {relative}')

    for forbidden in FORBIDDEN_DIRS:
        if (root / forbidden).exists():
            errors.append(f'Generated/cache directory must not be committed: {forbidden}')

    for path in root.rglob('*'):
        if not path.is_file():
            continue
        if any(part in {'.git', 'build', '.dart_tool'} for part in path.relative_to(root).parts):
            continue
        if path.suffix == '.zip':
            errors.append(f'ZIP artifact inside repository root: {path.relative_to(root)}')
        if not is_text_file(path):
            continue
        try:
            text = path.read_text(encoding='utf-8')
        except UnicodeDecodeError:
            continue
        for pattern in SECRET_PATTERNS:
            if pattern.search(text):
                errors.append(f'Potential secret pattern in {path.relative_to(root)}')
        for marker in SKELETON_MARKERS:
            if marker in text:
                errors.append(f'Skeleton marker {marker} in {path.relative_to(root)}')

    readme = root / 'README.md'
    if readme.exists() and len(readme.read_text(encoding='utf-8').strip()) < 800:
        warnings.append('README is short for a portfolio repository.')

    score = 100 - len(errors) * 25 - len(warnings) * 5
    return max(0, score), errors, warnings


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('root', nargs='?', default='.')
    parser.add_argument('--markdown', action='store_true')
    args = parser.parse_args()

    root = Path(args.root).resolve()
    score, errors, warnings = audit(root)
    status = 'public_grade_candidate' if score >= 85 and not errors else 'private_prototype'

    if args.markdown:
        print('# RDOS Quality Audit')
        print()
        print(f'- Score: {score}/100')
        print(f'- Status: {status}')
        print()
        print('## Errors')
        if errors:
            for item in errors:
                print(f'- {item}')
        else:
            print('- None')
        print()
        print('## Warnings')
        if warnings:
            for item in warnings:
                print(f'- {item}')
        else:
            print('- None')
    else:
        print(f'score={score} status={status}')
        for item in errors:
            print(f'ERROR: {item}')
        for item in warnings:
            print(f'WARNING: {item}')

    return 1 if errors else 0


if __name__ == '__main__':
    raise SystemExit(main())
