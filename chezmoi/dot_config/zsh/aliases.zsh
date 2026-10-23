# Dotfiles
alias zshrc='chezmoi edit ~/.zshrc'
alias zshconfig='code "$(chezmoi source-path ~/.config/zsh)"'
alias zdiff='chezmoi diff'
alias zapply='chezmoi apply'
alias reload='exec zsh'

# Files
alias ls='eza -aF --git --icons=auto' # brew "eza"
alias sl='ls'
alias l='eza -lahF --git --icons=auto'
alias ll='l'
alias man='batman' # brew "bat-extras"
alias c='clear'
alias tree='eza -T --icons=auto'

# Core utilities
alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# Navigation
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Docker
alias d='docker'
alias dc='docker compose'

# npm
alias nr='npm run'
alias ni='npm install'
alias nid='npm install --save-dev'
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'

# pnpm
alias pn='pnpm'

# Claude Code
alias cc="claude"
alias ccl='lumi-cli run claude --server-url "$LUMI_SERVER_URL" --api-key "$LUMI_API_KEY"'
alias ccp='lumi-cli run claude --subscription --server-url "$LUMI_SERVER_URL" --api-key "$LUMI_API_KEY"'

# Codex
alias cx="codex"
alias cxl='lumi-cli run codex --server-url "$LUMI_SERVER_URL" --api-key "$LUMI_API_KEY"'

# Display PATH entries one per line
alias trail='print -l -- $path'

# Java versions managed by mise
alias java21='mise shell java@temurin-21 && java -version'
alias java25='mise shell java@temurin-25 && java -version'
