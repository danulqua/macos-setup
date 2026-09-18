#!/bin/zsh

emulate -LR zsh
set -euo pipefail

readonly SCRIPT_DIR="${0:A:h}"
readonly REPOSITORY_ROOT="${SCRIPT_DIR:h}"

source "${SCRIPT_DIR}/lib.zsh"

readonly skip_packages="${MACOS_SETUP_SKIP_PACKAGES:-false}"
readonly skip_dotfiles="${MACOS_SETUP_SKIP_DOTFILES:-false}"
readonly skip_runtimes="${MACOS_SETUP_SKIP_RUNTIMES:-false}"
readonly skip_macos="${MACOS_SETUP_SKIP_MACOS:-false}"

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

# Install the system-wide zshenv configuration file.
sudo cp "${REPOSITORY_ROOT}/system/zshenv" /etc/zshenv
sudo chmod 644 /etc/zshenv
sudo chown root:wheel /etc/zshenv

# Create XDG zsh directories
mkdir -p \
  "${HOME}/.config/zsh" \
  "${HOME}/.cache/zsh" \
  "${HOME}/.local/state/zsh"

# Apply dotfiles
if [[ "${skip_dotfiles}" == false ]]; then
  heading "Applying dotfiles"
  chezmoi apply --source "${REPOSITORY_ROOT}/chezmoi"

  touch "${HOME}/.config/zsh/secrets.zsh" "${HOME}/.gitconfig.local"
  chmod 600 "${HOME}/.config/zsh/secrets.zsh" "${HOME}/.gitconfig.local"

  success "Dotfiles are applied"
fi

# Apply mise runtimes
if [[ "${skip_runtimes}" == false ]]; then
  heading "Installing mise runtimes"
  require_command mise
  mise install
  success "mise runtimes are installed"
fi

# Apply macOS settings
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
