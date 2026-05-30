# 100KM Goal — Functional Taxonomy

```text
100KM GOAL APP
│
├── 1. Central Objective
│   └── Record real walking/running progress toward 100 km.
│
├── 2. Home Screen
│   ├── Total distance
│   ├── Remaining distance
│   ├── Progress percentage
│   ├── Start session
│   └── History access
│
├── 3. Tracking Screen
│   ├── GPS permission check
│   ├── Position stream
│   ├── Distance accumulation
│   ├── Duration timer
│   ├── Average speed
│   ├── Pause / resume
│   └── Finish and save
│
├── 4. Integrity Layer
│   ├── Reject weak GPS accuracy
│   ├── Reject tiny noise segments
│   ├── Reject impossible speed jumps
│   └── Preserve only accepted route points
│
├── 5. History Layer
│   ├── Date
│   ├── Distance
│   ├── Duration
│   ├── Average speed
│   └── Route detail
│
├── 6. Storage Layer
│   ├── Local SharedPreferences
│   ├── JSON encoded run records
│   └── No server dependency
│
└── 7. Future Expansion
    ├── Background service
    ├── GPX export
    ├── Badges: 25 / 50 / 75 / 100 km
    └── Play Store release pipeline
```
