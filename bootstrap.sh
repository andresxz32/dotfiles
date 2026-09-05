#!/usr/bin/env bash
#
# Entry point for a brand-new macOS or Linux machine.
# Usage (from a fresh machine):
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/andresxz32/dotfiles/main/bootstrap.sh)"
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
