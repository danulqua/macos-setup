# Load completion system
autoload -Uz compinit

# Initialize completion with cached metadata file
compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"

# Enable interactive completion menu selection
zstyle ':completion:*' menu select

# Make completion case-insensitive
# Example: "doc" can complete to "Documents"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls
