param(
    [switch]$AndroidOnly = $true
)

$ErrorActionPreference = "Stop"

Write-Host "[RDOS] Checking Flutter..."
flutter --version

Write-Host "[RDOS] Generating platform folders if missing..."
if ($AndroidOnly) {
    flutter create --platforms=android .
} else {
    flutter create .
}

Write-Host "[RDOS] Installing dependencies..."
flutter pub get

Write-Host "[RDOS] Running tests..."
flutter test

Write-Host "[RDOS] Bootstrap complete. Run: flutter run"
