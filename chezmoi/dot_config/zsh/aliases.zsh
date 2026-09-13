# Dotfiles
alias zshrc='chezmoi edit ~/.zshrc'
alias zshconfig='code "$(chezmoi source-path ~/.config/zsh)"'
alias zdiff='chezmoi diff'
alias zapply='chezmoi apply'
alias reload='exec zsh'

# Files
alias ls='eza -aF --git --icons' # brew "eza"
alias sl='ls'
alias l='eza -lahF --git --icons'
alias ll='l'
alias man='batman' # brew "bat-extras"
alias c='clear'
alias rm='trash' # brew "trash"

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

# Display PATH entries one per line
alias trail='print -l -- $path'

# Java versions managed by mise
alias java21='mise shell java@temurin-21 && java -version'
alias java25='mise shell java@temurin-25 && java -version'
