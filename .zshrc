export PATH="$HOME/.local/bin:$PATH"

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

autoload -Uz compinit && compinit

alias ll='ls -lah'
alias la='ls -lAh'
alias ..='cd ..'
alias ...='cd ../..'
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias d='docker'
alias dc='docker-compose'
alias dev='cd ~/Developer 2>/dev/null || cd ~/'

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
command -v starship &> /dev/null && eval "$(starship init zsh)"