# 100KM Goal

One-line mission: a privacy-first Flutter application that records real walking or running sessions locally and shows progress toward a personal 100 km goal.

## Problem

A runner or student often wants a simple, private and verifiable history of progress without a social platform, cloud account, subscription, or public leaderboard. This project records GPS-based sessions on the phone, stores them locally, and converts them into a clean personal history toward a 100 km objective.

## Implemented Features

- Local progress dashboard: total distance, remaining distance, and completion ratio.
- GPS session tracking with distance, duration, average speed, and route points.
- Internal run history stored on the device with no server dependency.
- Route detail screen using OpenStreetMap through `flutter_map`.
- Basic integrity filters for impossible GPS jumps and excessive speed.
- RDOS documentation, security audit script, manifest generation, and release packaging.

## Project Status

- Current stage: **prototype / RDOS M1**.
- Public status: **private_prototype until tested on a real Android device**.
- Target platform: Android first; iOS can be generated later from the same Flutter source.
- Data policy: local-only; no cloud synchronization is implemented.

## Installation

```bash
flutter --version
flutter create --platforms=android .
flutter pub get
flutter run
```

If Flutter is not recognized, install Flutter SDK and add Flutter `bin` to the Windows PATH before running the commands.

## Usage

```text
Home Screen
├── Total distance: 0.00 / 100 km
├── Remaining distance
├── Progress bar
├── Start / Continue button
└── History button

Tracking Screen
├── Start tracking
├── Pause / Resume
├── Finish and save
└── Route points are collected from GPS

History Screen
├── Saved sessions
├── Date
├── Distance
├── Duration
└── Detail route screen
```

## Project Structure

```text
YASSER_100KM_GOAL_RDOS/
├── README.md
├── pubspec.yaml
├── analysis_options.yaml
├── .gitignore
├── LICENSE
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   ├── models/
│   ├── screens/
│   ├── services/
│   └── widgets/
├── test/
├── docs/
├── rdos/
├── scripts/
└── .github/workflows/
```

## Tests

```bash
flutter test
python scripts/audit_repository_quality.py . --markdown
python scripts/generate_manifest.py . --output rdos/manifest/PROJECT_MANIFEST.sha256
python scripts/package_release.py . --output ../YASSER_100KM_GOAL_RDOS_release.zip --strict
```

## Privacy Model

The app stores all sessions locally through `SharedPreferences`. It does not contain login, backend, analytics, tracking SDK, ads, or server upload. Location permission is required only to record the user's own route.

## Known Limitations

- The prototype must be tested on a real Android device for GPS accuracy.
- Background tracking is not hardened yet; the screen should stay active during early tests.
- The app does not claim medical accuracy.
- Anti-cheat is basic and designed for personal honesty, not official competition.

## RDOS Quality Gate

This repository follows a minimal RDOS discipline:

- README is non-empty and executable.
- Documentation explains mission, architecture, security, limits and publishing.
- Scripts generate a manifest, run a local quality audit and package a release zip.
- Secrets, build folders and generated artifacts are excluded from version control.
- The repository should remain private until device execution is verified.

## License

MIT License. See `LICENSE`.
