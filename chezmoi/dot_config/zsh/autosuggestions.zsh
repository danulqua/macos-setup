if command -v brew >/dev/null 2>&1; then
  autosuggestions_file="$(
    brew --prefix
  )/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

  [[ -r "$autosuggestions_file" ]] &&
    source "$autosuggestions_file"

  unset autosuggestions_file
fi
