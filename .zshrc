# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set powerlevel10k theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable plugins
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  fzf-tab
  docker
  kubectl
  ansible
  tmux
  vscode
)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=$HOME/.local/bin:/venv/bin:$PATH
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias ll="ls -la"
alias la="ls -A"
alias l="ls -CF"
alias gs="git status"
alias gco="git checkout"
alias gcm="git commit -m"
alias gca="git commit --amend --no-edit"
alias gst="git stash"
alias gsta="git stash apply"
alias gstl="git stash list"
alias gp="git push"
alias gpl="git pull"
alias gb="git branch"
alias gl="git log --oneline"
alias k="kubectl"
alias tf="terraform"
alias a="ansible"
alias ap="ansible-playbook"
alias up="docker compose up"
alias down="docker compose down"
alias ps="docker compose ps"
alias logs="docker compose logs -f"

# Dotfiles related aliases
alias dotdoc="readme"                          # Show dotfiles documentation
alias dotinstall="readme install"              # Show installation instructions
alias dotconfig="readme config"                # Show configuration guide
alias dotcheat="readme cheat"                  # Show cheatsheet
alias dotaliases="readme alias"                # Show all aliases
alias dothelp="readme --format terminal"       # Show help with formatting

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Ignore sensitive commands in history
export HISTIGNORE="*SECRET*:*PASS*:*TOKEN*:*KEY*:*CREDENTIAL*:*PRIVATE*:*AUTH*:*PWD*:*SSH*:*GPG*:*API*:*ACCESS*:*SESSION*"

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Completion system
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Enable keyboard shortcuts
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^H' backward-delete-char

# Source powerlevel10k config if exists
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Load custom functions if they exist
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

# Load local configs if they exist
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
