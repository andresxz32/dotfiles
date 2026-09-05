#!/usr/bin/env bash
# Run this after installing/removing anything with brew or a VS Code extension,
# to keep packages/Brewfile as the accurate source of truth.
#
# Usage: ./scripts/update-packages.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Dumping current Homebrew state (formulae, casks, taps, VS Code extensions)..."
brew bundle dump --file="$REPO_ROOT/packages/Brewfile" --force --vscode

echo "==> Done. Review the diff before committing:"
echo "    git -C \"$REPO_ROOT\" diff packages/Brewfile"
