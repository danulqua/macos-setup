#!/bin/zsh

emulate -LR zsh
set -euo pipefail

readonly REPOSITORY="danulqua/macos-setup"
readonly REPOSITORY_URL="https://github.com/${REPOSITORY}.git"

info() {
  print -- "\n==> $*"
}

fail() {
  print -u2 -- "Error: $*"
  exit 1
}

if [[ "$(uname -s)" != "Darwin" ]]; then
  fail "This bootstrap supports macOS only."
fi

if ! xcode-select -p >/dev/null 2>&1; then
  info "Installing Xcode Command Line Tools"
  xcode-select --install 2>/dev/null || true
  print "Finish the installation in the dialog. This script will continue automatically."

  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done
fi

if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  fail "Homebrew was installed, but its executable could not be found."
fi

if ! command -v chezmoi >/dev/null 2>&1; then
  info "Installing chezmoi"
  brew install chezmoi
fi

source_path="$(chezmoi source-path)"

if repository_root="$(git -C "${source_path}" rev-parse --show-toplevel 2>/dev/null)"; then
  origin_url="$(git -C "${repository_root}" remote get-url origin 2>/dev/null || true)"

  if [[ "${origin_url}" != *"github.com/danulqua/macos-setup"* ]]; then
    fail "The chezmoi source directory belongs to another repository: ${origin_url:-unknown}"
  fi

  info "Updating setup repository"
  git -C "${repository_root}" pull --ff-only
else
  if [[ -d "${source_path}" ]] && [[ -n "$(ls -A "${source_path}" 2>/dev/null)" ]]; then
    fail "The chezmoi source directory is not empty: ${source_path}"
  fi

  info "Downloading setup repository"
  chezmoi init "${REPOSITORY_URL}"
  source_path="$(chezmoi source-path)"
  repository_root="$(git -C "${source_path}" rev-parse --show-toplevel)"
fi

exec "${repository_root}/scripts/install.zsh" "$@"
