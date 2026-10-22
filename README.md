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

## Russian stadium archive (v0.2)

The interface is Russian. **Архив → Пример: ИРНИТУ** shows 30 deterministic
**demonstration** sessions from 1 July to 28 August 2026, every other day.
Morning sessions start and finish within 07:00–09:00; evening sessions fit
17:00–18:00. All displayed times use Irkutsk time (UTC+8), independently of
phone timezone. Example pace varies around 8–11 km/h; distances, lap counts,
durations and finishing times agree mathematically.

Tap a session to play an offline **schematic** stadium replay. The dot runs
around a conceptual 400 m lap; this is not a surveyed track outline or historical
GPS evidence. Play/pause, restart, scrubbing and ×1/×10/×30 playback are available.
Expand the venue map to locate the stadium (internet required). Venue pin source:
https://orgeo.ru/place/11930 (52.262993, 104.265678); university venue information:
https://www.istu.edu/deyatelnost/sport/upss/stadion .

Examples are generated in memory, carry `isDemo`, and have no fabricated GPS
points. They never enter phone storage or personal goal totals. **Мои записи**
preserves existing real recordings and their maps; deleting one requires
confirmation. New optional record fields retain compatibility with old data.

The APK is built by Actions for `main` and pull requests.
Download the artifact **hundred-km-goal-stadium-ru-apk** and extract `app-debug.apk`.
This is a debug build for installation/testing on an Android phone.
