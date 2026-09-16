if command -v brew >/dev/null 2>&1; then
  syntax_highlighting_file="$(
    brew --prefix
  )/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

  [[ -r "$syntax_highlighting_file" ]] &&
    source "$syntax_highlighting_file"

  unset syntax_highlighting_file
fi
