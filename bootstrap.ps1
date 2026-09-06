#Requires -Version 5.1
<#
    Entry point for a brand-new Windows machine.
    Usage (from an elevated PowerShell prompt):
      irm https://raw.githubusercontent.com/andresxz32/dotfiles/main/bootstrap.ps1 | iex
#>

$ErrorActionPreference = "Stop"

$DotfilesRepo = "https://github.com/andresxz32/dotfiles.git"

function Write-Info($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }

# --- 1. Ensure winget is available ----------------------------------------
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget not found. Install 'App Installer' from the Microsoft Store first, then re-run this script."
    return
}

# --- 2. Install chezmoi via winget -----------------------------------------
if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
    Write-Info "Installing chezmoi..."
    winget install --id twpayne.chezmoi -e --accept-package-agreements --accept-source-agreements
    $env:Path += ";$env:LOCALAPPDATA\Microsoft\WinGet\Packages"
}

# --- 3. Offer WSL2 setup (recommended dev environment) ---------------------
# Note: wsl.exe returns a non-zero exit code when the WSL feature isn't
# installed at all. On PowerShell 7.3+, $ErrorActionPreference = "Stop"
# turns that into a terminating error even with stderr redirected to $null,
# so this has to be wrapped in try/catch rather than relying on redirection.
$wslInstalled = $false
try {
    $null = wsl --list --quiet 2>$null
    if ($LASTEXITCODE -eq 0) { $wslInstalled = $true }
} catch {
    $wslInstalled = $false
}

if (-not $wslInstalled) {
    $installWsl = Read-Host "WSL2/Ubuntu not detected. Install it now? (recommended) [Y/n]"
    if ($installWsl -ne "n") {
        Write-Info "Installing WSL2 + Ubuntu..."
        wsl --install -d Ubuntu
        Write-Host "WSL2 is installing. Reboot when prompted, then re-run this script to continue." -ForegroundColor Yellow
        Read-Host "Press Enter to close this window"
        return
    }
}

# --- 4. Initialize and apply the dotfiles repo (Windows-layer config) ------
Write-Info "Cloning and applying dotfiles..."
chezmoi init --apply $DotfilesRepo

Write-Info "Done. If you installed WSL2, open Ubuntu and run bootstrap.sh inside it to set up the *nix side."
