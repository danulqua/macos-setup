# Create exactly one directory and enter it.
mkcd() {
  if (( $# != 1 )); then
    echo "Usage: mkcd <directory>" >&2
    return 1
  fi

  mkdir -p -- "$1" && cd -- "$1"
}

# Select a bat theme based on the current macOS appearance.
bat() {
  local theme

  if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
    theme="Dracula"
  else
    theme="GitHub"
  fi

  command bat --theme="$theme" "$@"
}

# Regenerate the repository Brewfile.
# Always inspect the diff afterward because dump captures installed state.
brew-dump() {
  local repo_root

  repo_root="$(chezmoi execute-template '{{ .chezmoi.workingTree }}')" ||
    return 1

  brew bundle dump \
    --file="$repo_root/Brewfile" \
    --force \
    --describe
}
