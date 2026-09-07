#!/usr/bin/env bash
#
# Entry point for a brand-new macOS or Linux machine.
# Usage (from a fresh machine):
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/andresxz32/dotfiles/main/bootstrap.sh)"
#
set -euo pipefail

DOTFILES_REPO="git@github.com:andresxz32/dotfiles.git"
# Fallback to HTTPS if the machine has no SSH key registered yet
DOTFILES_REPO_HTTPS="https://github.com/andresxz32/dotfiles.git"

info()  { printf "\033[1;34m==>\033[0m %s\n" "$1"; }
error() { printf "\033[1;31mERROR:\033[0m %s\n" "$1" >&2; }

# --- 1. Install Homebrew if missing (works on macOS and Linux) -----------
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -d "/opt/homebrew/bin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"      # Apple Silicon
  elif [[ -d "/home/linuxbrew/.linuxbrew/bin" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  # Linux
  fi
fi

# --- 2. Install chezmoi via Homebrew --------------------------------------
if ! command -v chezmoi &>/dev/null; then
  info "Installing chezmoi..."
  brew install chezmoi
fi

# --- 3. Initialize and apply the dotfiles repo ----------------------------
info "Cloning and applying dotfiles..."
if ! chezmoi init --apply "$DOTFILES_REPO" 2>/dev/null; then
  info "SSH clone failed, falling back to HTTPS..."
  chezmoi init --apply "$DOTFILES_REPO_HTTPS"
fi

info "Done. Restart your terminal (or run 'exec zsh') to pick up the new shell config."

# --- 4. Set zsh as the default login shell --------------------------------
# Without this, a fresh Linux/WSL install stays on bash by default, which
# never sources ~/.zshrc -- so Homebrew's PATH, mise, starship, and every
# alias silently appear "missing" even though they installed correctly.
#
# Two gotchas discovered the hard way:
# - `chsh` silently refuses any shell path not listed in /etc/shells, and
#   Homebrew's zsh (a non-standard path) is never added there automatically.
# - a bare `chsh -s <path>` can be a no-op if the account's shell field in
#   /etc/passwd is empty/unusual, so we pass the username explicitly via sudo.
ZSH_PATH="$(command -v zsh || true)"
if [[ -n "$ZSH_PATH" && "$SHELL" != "$ZSH_PATH" ]]; then
  info "Registering $ZSH_PATH in /etc/shells..."
  grep -qxF "$ZSH_PATH" /etc/shells 2>/dev/null || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null

  info "Setting zsh as your default shell (you may be asked for your password)..."
  if sudo chsh -s "$ZSH_PATH" "$(whoami)" 2>/dev/null || chsh -s "$ZSH_PATH" 2>/dev/null; then
    info "Default shell changed to zsh. Fully restart your terminal session for it to take effect."
    info "(On WSL specifically: run 'wsl --shutdown' from Windows, then reopen.)"
  else
    info "Could not change shell automatically. Run this manually: sudo chsh -s $ZSH_PATH \$(whoami)"
  fi
fi