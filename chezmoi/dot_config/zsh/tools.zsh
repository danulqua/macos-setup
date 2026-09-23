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

# Ghostty terminal shell integration. Need to do this manually because of the
# changed ZDOTDIR, see: https://github.com/ghostty-org/ghostty/discussions/7251#discussioncomment-16490310
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi
