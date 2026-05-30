param(
    [Parameter(Mandatory=$true)]
    [string]$RemoteUrl
)

$ErrorActionPreference = "Stop"

Write-Host "[RDOS] Initializing Git repository..."
if (-not (Test-Path ".git")) {
    git init
}

git branch -M main

git status

Write-Host "[RDOS] Staging controlled project files..."
git add README.md pubspec.yaml analysis_options.yaml .gitignore LICENSE lib test docs rdos scripts .github assets

git status

Write-Host "[RDOS] Creating initial commit if needed..."
$hasCommit = $true
try {
    git rev-parse --verify HEAD | Out-Null
} catch {
    $hasCommit = $false
}

if (-not $hasCommit) {
    git commit -m "feat: initialize 100km goal app under RDOS"
} else {
    git commit -m "chore: update 100km goal RDOS project" 2>$null
}

if (-not (git remote | Select-String -Pattern "^origin$")) {
    git remote add origin $RemoteUrl
}

git push -u origin main

Write-Host "[RDOS] Push complete. Inspect the repository page immediately."
