# Basic shell aliases for public dotfiles
# These are generic aliases safe for public sharing

# Navigation shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# List files with better defaults
alias ll="ls -la"
alias la="ls -A"
alias l="ls -CF"

# Common commands with safety and color
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias mkdir="mkdir -p"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# System information
alias df="df -h"
alias du="du -h"
alias free="free -h"
alias ports="netstat -tulanp"

# Git shortcuts
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"

# Docker shortcuts
alias d="docker"
alias dc="docker compose"
alias dps="docker ps"

# Quick directory navigation
alias home="cd ~"
alias root="cd /"

# Show directory size
alias dirsize="du -sh"

# Network
alias myip="curl -s http://ipinfo.io/ip"
alias ping="ping -c 5"