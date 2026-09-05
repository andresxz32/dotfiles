#Requires -Version 5.1
# Run this after installing/removing anything with winget,
# to keep packages/winget.json as the accurate source of truth.
#
# Usage: .\scripts\update-packages.ps1
$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$OutFile  = Join-Path $RepoRoot "packages\winget.json"

Write-Host "==> Exporting current winget package state..."
winget export -o $OutFile --accept-source-agreements

Write-Host "==> Done. Review the diff before committing:"
Write-Host "    git -C `"$RepoRoot`" diff packages/winget.json"
