#!/usr/bin/env bash
# Helper to add pyenv initialization to bash_profile and install Python 3.12.6 locally
set -e
PROFILE="$HOME/.bash_profile"
PYTHON_VERSION="3.12.6"

if ! grep -q "pyenv" "$PROFILE" 2>/dev/null; then
  cat >> "$PROFILE" <<'BASH'
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi
BASH
  echo "Added pyenv init to $PROFILE"
else
  echo "pyenv init already present in $PROFILE"
fi

# Source the profile to make pyenv available in this shell
# Note: run this script with 'source scripts/activate_pyenv.sh' to have effect in current shell
# If run directly, it will still attempt to run pyenv commands but won't persist PATH changes
source "$PROFILE" || true

if ! command -v pyenv >/dev/null 2>&1; then
  echo "pyenv not found on PATH. Make sure Homebrew's bin directory is in your PATH, then reopen your terminal or run: source $PROFILE"
  exit 1
fi

# Install python version if missing
if ! pyenv versions --bare | grep -qx "$PYTHON_VERSION"; then
  echo "Installing Python $PYTHON_VERSION via pyenv (this may take several minutes)..."
  pyenv install "$PYTHON_VERSION"
else
  echo "Python $PYTHON_VERSION already installed in pyenv"
fi

# Set local python for this project
cd "$(dirname "$0")/.." || true
pyenv local "$PYTHON_VERSION"

# final verification
echo "Local pyenv python: $(pyenv which python)"
echo "Python version: $(python --version)"

echo "Done. If you used a different shell (zsh), add the same lines to your shell profile and reload it."