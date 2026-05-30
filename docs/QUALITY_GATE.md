# RDOS Quality Gate

## Before First GitHub Push

```text
Gate 01 — Structure
├── README.md exists
├── pubspec.yaml exists
├── lib/ exists
├── test/ exists
├── docs/ exists
├── scripts/ exists
└── .gitignore exists

Gate 02 — Security
├── No .env
├── No private key
├── No keystore
├── No token pattern
└── No build artifacts

Gate 03 — Reproducibility
├── flutter pub get documented
├── flutter run documented
├── flutter test documented
└── package script available

Gate 04 — Honesty
├── Status is prototype
├── Limits are explicit
├── No fake certification claim
└── No fake data claim
```

## Required Local Commands

```bash
flutter pub get
flutter test
python scripts/audit_repository_quality.py . --markdown
python scripts/generate_manifest.py . --output rdos/manifest/PROJECT_MANIFEST.sha256
python scripts/package_release.py . --output ../YASSER_100KM_GOAL_RDOS_release.zip --strict
```
