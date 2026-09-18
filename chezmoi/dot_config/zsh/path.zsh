typeset -U path PATH

# Homebrew: Apple Silicon first, Intel fallback.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Personal scripts should take precedence.
export PATH="$HOME/.local/bin:$PATH"
