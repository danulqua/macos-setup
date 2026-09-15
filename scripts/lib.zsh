#!/bin/zsh

emulate -LR zsh
set -euo pipefail

if [[ -t 1 ]]; then
  readonly BOLD=$'\e[1m'
  readonly GREEN=$'\e[32m'
  readonly YELLOW=$'\e[33m'
  readonly RESET=$'\e[0m'
else
  readonly BOLD=""
  readonly GREEN=""
  readonly YELLOW=""
  readonly RESET=""
fi

heading() {
  print -- "\n${BOLD}==> $*${RESET}"
}

success() {
  print -- "${GREEN}✓${RESET} $*"
}

warning() {
  print -u2 -- "${YELLOW}!${RESET} $*"
}

fail() {
  print -u2 -- "Error: $*"
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}
