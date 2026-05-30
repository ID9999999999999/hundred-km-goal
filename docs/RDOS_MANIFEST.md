# RDOS Manifest — 100KM Goal

## Identity

- Project name: `100KM Goal`
- Repository name: `hundred-km-goal` or `YASSER_100KM_GOAL_RDOS`
- Owner: Yasser Idbouzkri
- Mode: RDOS M1 — serious private prototype
- Public decision: private until Android execution is verified

## Mission

Build a simple, local-first running and walking tracker that records real GPS sessions and shows progress toward 100 km.

## Proof Objects

```text
Proof Layer
├── Source code
│   ├── lib/main.dart
│   ├── lib/screens/
│   ├── lib/services/
│   └── lib/models/
├── Reproducibility
│   ├── pubspec.yaml
│   ├── analysis_options.yaml
│   └── README.md commands
├── Quality
│   ├── test/distance_service_test.dart
│   ├── .github/workflows/flutter-ci.yml
│   └── scripts/audit_repository_quality.py
├── Security
│   ├── .gitignore anti-secret rules
│   ├── docs/SECURITY_MODEL.md
│   └── local-only storage design
└── Packaging
    ├── scripts/generate_manifest.py
    └── scripts/package_release.py
```

## Non-Goals

- No fake run injection.
- No leaderboard.
- No social network.
- No cloud sync in the prototype.
- No medical or official competition certification.

## Quality Decision

This project should be pushed to GitHub as **private** first. It can become public only after real-device execution, screenshots, and CI success.
