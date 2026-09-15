#!/bin/zsh

emulate -LR zsh
set -euo pipefail

readonly SCRIPT_DIR="${0:A:h}"
readonly REPOSITORY_ROOT="${SCRIPT_DIR:h}"
readonly PROGRAM_NAME="${0:t}"

source "${SCRIPT_DIR}/lib.zsh"

skip_packages=false
skip_dotfiles=false
skip_runtimes=false
skip_macos=false

usage() {
  print "Usage: ${PROGRAM_NAME} [options]"
  print ""
  print "Options:"
  print "  --skip-packages   Do not run Homebrew Bundle"
  print "  --skip-dotfiles   Do not apply chezmoi-managed files"
  print "  --skip-runtimes   Do not install tools declared in mise"
  print "  --skip-macos      Do not apply macOS settings and shortcuts"
  print "  -h, --help        Show this help"
}

while (( $# > 0 )); do
  case "$1" in
    --skip-packages) skip_packages=true ;;
    --skip-dotfiles) skip_dotfiles=true ;;
    --skip-runtimes) skip_runtimes=true ;;
    --skip-macos) skip_macos=true ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      print -u2 "Unknown option: $1"
      usage >&2
      exit 2
      ;;
  esac
  shift
done

[[ "$(uname -s)" == "Darwin" ]] || fail "This installer supports macOS only."
[[ -f "${REPOSITORY_ROOT}/Brewfile" ]] || fail "Brewfile not found in ${REPOSITORY_ROOT}."

require_command brew
require_command chezmoi

if [[ "${skip_packages}" == false ]]; then
  heading "Installing Homebrew packages and applications"
  brew bundle --file="${REPOSITORY_ROOT}/Brewfile"
  success "Homebrew bundle is installed"
fi

# Configure the full Xcode installation.
XCODE_DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

if [[ -d "${XCODE_DEVELOPER_DIR}" ]]; then
  heading "Configuring Xcode"

  if [[ "$(xcode-select -p 2>/dev/null || true)" != "${XCODE_DEVELOPER_DIR}" ]]; then
    sudo xcode-select --switch "${XCODE_DEVELOPER_DIR}"
  fi

  if ! xcodebuild -checkFirstLaunchStatus >/dev/null 2>&1; then
    sudo xcodebuild -runFirstLaunch
  fi

  success "Xcode is configured"
fi

unset XCODE_DEVELOPER_DIR

if [[ "${skip_dotfiles}" == false ]]; then
  heading "Applying dotfiles"
  chezmoi apply --source "${REPOSITORY_ROOT}/chezmoi"

  mkdir -p "${HOME}/.config/zsh"
  touch "${HOME}/.config/zsh/secrets.zsh" "${HOME}/.gitconfig.local"
  chmod 600 "${HOME}/.config/zsh/secrets.zsh" "${HOME}/.gitconfig.local"
  success "Dotfiles are applied"
fi

if [[ "${skip_runtimes}" == false ]]; then
  heading "Installing mise runtimes"
  require_command mise
  mise install
  success "mise runtimes are installed"
fi

if [[ "${skip_macos}" == false ]]; then
  heading "Applying macOS settings"
  "${REPOSITORY_ROOT}/macos/macos.zsh"
  success "macOS settings are applied"
fi

heading "Setup complete"
print "Restart the terminal, then run:"
print "  ${BOLD}${REPOSITORY_ROOT}/scripts/check.zsh${RESET}"
print ""
print "Manual steps still required:"
print "  1. Add your identity to ~/.gitconfig.local"
print "  2. Add secrets to ~/.config/zsh/secrets.zsh"
print "  3. Create and register your GitHub SSH key"
print "  4. Sign in to installed applications"
