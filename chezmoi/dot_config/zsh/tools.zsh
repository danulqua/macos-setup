# Runtime manager
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Fuzzy finder
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Directory navigation
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# This must remain the final tool initialized in .zshrc.
if command -v brew >/dev/null 2>&1; then
  syntax_highlighting_file="$(
    brew --prefix
  )/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

  [[ -r "$syntax_highlighting_file" ]] &&
    source "$syntax_highlighting_file"

  unset syntax_highlighting_file
fi
