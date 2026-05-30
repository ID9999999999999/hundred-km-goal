# 100KM Goal

A real local-first Flutter application for recording walking or running sessions and building a private 100 km progress history.

## What the app does

- Records real outdoor sessions using phone location.
- Calculates distance, duration, average speed, and route points.
- Saves sessions locally on the phone.
- Shows a dedicated **100KM Passport / جواز 100 كيلومتر** inside History.
- Marks each session as a passport stamp.
- Shows whether the average speed is walking, slow easy running, normal running, or fast running.
- Uses a slow-running reference band of **6.0–8.5 km/h**.
- Builds an Android APK through GitHub Actions without installing Flutter locally.

## User flow

```text
Home
├── Start run
│   ├── ask location permission
│   ├── record route points
│   ├── show distance / duration / average speed
│   └── finish and save
└── Open 100KM Passport
    ├── completed distance
    ├── remaining distance
    ├── progress bar
    └── session stamps
```

## Build from GitHub

Open the repository on GitHub:

```text
Actions → Build Android APK → Run workflow
```

When it succeeds, download:

```text
hundred-km-goal-real-app-apk
```

Inside the ZIP you will find:

```text
app-debug.apk
```

Install this APK on Android and allow location permission when the app asks.

## Test

For the first test, walk or jog outdoors for 30–100 meters, finish the session, then open History.
The session should appear as a stamp inside the 100KM Passport.
