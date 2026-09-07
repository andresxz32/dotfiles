# dotfiles

Personal, multi-platform dev environment provisioning, powered by [chezmoi](https://www.chezmoi.io/).

One repo → macOS, Linux, and Windows (via WSL2 for the *nix layer + a thin native layer for Windows Terminal / PowerShell).

## Bootstrap a new machine

**macOS / Linux:**
```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/andresxz32/dotfiles/main/bootstrap.sh)"
```

**Windows (PowerShell, run as your normal user):**
```powershell
irm https://raw.githubusercontent.com/andresxz32/dotfiles/main/bootstrap.ps1 | iex
```
If WSL2 isn't installed yet, the script installs it, asks you to reboot, and to re-run itself.
Then open Ubuntu and run the macOS/Linux command above inside WSL for the shell/editor config.

## Repo layout

```
.chezmoiroot                          # points chezmoi to home/ as the actual source root
README.md, bootstrap.sh, bootstrap.ps1, packages/, scripts/   # plain repo files — never applied to $HOME

home/                                  # everything below this line maps onto $HOME
  .chezmoi.toml.tmpl                   # one-time prompts (name, email, profile, useWSL)
  .chezmoiignore                       # OS-conditional file exclusion
  .chezmoiscripts/
    unix/       run_once_before_10-install-packages.sh.tmpl
                run_onchange_after_20-mise-install.sh.tmpl
    windows/    run_once_before_10-install-packages.ps1.tmpl
                run_onchange_after_20-mise-install.ps1.tmpl
  dot_zshrc.tmpl                       # -> ~/.zshrc
  dot_gitconfig.tmpl                   # -> ~/.gitconfig
  dot_config/
    starship.toml                     # -> ~/.config/starship.toml (shared prompt, all OSes)
    mise/config.toml                  # -> ~/.config/mise/config.toml (runtime versions)
    nvim/                             # -> ~/.config/nvim (LazyVim-based)
    wezterm/wezterm.lua.tmpl          # -> ~/.config/wezterm/wezterm.lua
    Code/User/settings.json.tmpl      # -> ~/.config/Code/User/settings.json (Linux)
  Library/Application Support/Code/User/settings.json.tmpl   # -> macOS VS Code settings
  Documents/PowerShell/Microsoft.PowerShell_profile.ps1.tmpl # -> $PROFILE (Windows)
  AppData/Local/Microsoft/Windows Terminal/Fragments/...     # -> WT fragment (Windows)

packages/
  Brewfile                            # macOS + Linux packages, casks, VS Code extensions
  winget.json                         # Windows packages (winget export format)

scripts/
  update-packages.sh / .ps1           # regenerate the manifests above from what's actually installed
```

**Why `.chezmoiroot`:** without it, chezmoi applies *everything* in the repo to `$HOME` — including `README.md` and `scripts/`. Pointing it at `home/` keeps repo scaffolding (docs, maintenance scripts, package manifests) separate from what actually lands on your filesystem.

**Why `.chezmoiscripts/<os>/`:** chezmoi executes whatever script it finds regardless of a `.sh` vs `.ps1` extension matching the current OS. Without this split, a `chezmoi apply` on Windows would try to execute the Bash install script (and fail) alongside the PowerShell one. Splitting into `unix/` and `windows/` subfolders lets `.chezmoiignore` cleanly exclude the wrong one per machine.

## Everyday commands

| Task | Command |
|---|---|
| Edit a managed file | `chezmoi edit ~/.zshrc` |
| Preview pending changes | `chezmoi diff` |
| Apply changes | `chezmoi apply` |
| Pull latest + apply | `chezmoi update` |
| Re-run package install after editing Brewfile | rename script to `run_onchange_` or `chezmoi state delete-bucket --bucket=scriptState` |
| Refresh `Brewfile` from what's actually installed | `./scripts/update-packages.sh` |
| Refresh `winget.json` from what's actually installed | `.\scripts\update-packages.ps1` |
| Change default runtime versions | edit `home/dot_config/mise/config.toml`, then `chezmoi apply` (auto-runs `mise install`) |

## Status

- [x] Phase 1 — bootstrap scripts + chezmoi base structure
- [x] Phase 2 — Zsh, Git config, and shared Starship prompt
- [x] Phase 3 — Windows-native layer (PowerShell profile, Windows Terminal fragment, WezTerm) + Nerd Fonts
- [x] Phase 4 — Neovim (LazyVim) + VS Code settings/extensions
- [x] Phase 5 — mise runtime manager (Node/Python/Rust/Go defaults)
- [x] Phase 6 — `.chezmoiroot` + `.chezmoiscripts/` correctness fix, plus `scripts/update-packages.*` to keep manifests real and versioned

## Important: before your first real run

The `packages/` manifests still contain **starter package lists**, not a real export from a working machine. Once you've set up one machine by hand with the apps you actually want:

```sh
./scripts/update-packages.sh      # macOS/Linux — regenerates packages/Brewfile
```
```powershell
.\scripts\update-packages.ps1     # Windows — regenerates packages/winget.json
```
Commit the result. From then on, every fresh machine installs the *exact* versions you're actually running — not the placeholders from this scaffold.


# IP + RAM + CPU in the bottom status bar
set -g status-right "IP: #(hostname -I | awk '{print $1}') | RAM: #(free -m | awk '/Mem/{printf $3\"/\"$2\"MB \"$7}') | CPU: #(top -bn1 | grep \"Cpu(s)\" | awk '{print $2\"%\"}') | %H:%M"
set -g status-right-length 60