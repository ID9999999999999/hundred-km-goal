# Architecture

## Layer Map

```text
lib/
├── main.dart
├── app.dart
├── core/
│   └── app_constants.dart
├── models/
│   ├── geo_point.dart
│   └── run_record.dart
├── services/
│   ├── distance_service.dart
│   ├── location_permission_service.dart
│   └── run_storage_service.dart
├── screens/
│   ├── home_screen.dart
│   ├── tracking_screen.dart
│   ├── history_screen.dart
│   └── run_detail_screen.dart
└── widgets/
    └── metric_card.dart
```

## Data Flow

```text
GPS Position Stream
→ GeoPoint
→ Integrity Filter
→ DistanceService
→ TrackingScreen State
→ RunRecord
→ RunStorageService
→ History Screen
→ Progress Dashboard
```

## Design Rule

Each layer has one responsibility:

- models hold structured data;
- services compute, validate or persist;
- screens coordinate user interaction;
- widgets render reusable visual blocks.
