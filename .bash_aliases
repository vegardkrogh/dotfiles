# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# List files
alias ll="ls -la"
alias la="ls -A"
alias l="ls -CF"

# Common commands with better defaults
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias mkdir="mkdir -p"
alias df="df -h"
alias du="du -h"
alias free="free -h"

# Git shortcuts
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend --no-edit"
alias gco="git checkout"
alias gb="git branch"
alias gpl="git pull"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff"
alias gst="git stash"
alias gsta="git stash apply"
alias gstl="git stash list"

# Docker/Container shortcuts
alias d="docker"
alias dc="docker compose"
alias up="docker compose up"
alias down="docker compose down"
alias ps="docker compose ps"
alias logs="docker compose logs -f"
alias dps="docker ps"
alias di="docker images"
alias drmi="docker rmi"
alias drm="docker rm"
alias dexec="docker exec -it"

# Ansible shortcuts
alias a="ansible"
alias ap="ansible-playbook"
alias al="ansible-lint"
alias ag="ansible-galaxy"
alias av="ansible-vault"
alias ai="ansible-inventory"

# Kubernetes
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kgn="kubectl get nodes"
alias ka="kubectl apply -f"
alias kd="kubectl delete"
alias kl="kubectl logs"
alias ke="kubectl exec -it"

# Terraform
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfd="terraform destroy"

# Python
alias py="python3"
alias pip="pip3"
alias venv="python3 -m venv venv"
alias activate="source venv/bin/activate"

# Network
alias myip="curl -s http://ipinfo.io/ip"
alias ports="netstat -tulanp"
alias ping="ping -c 5"

# System
alias update="sudo apt update && sudo apt upgrade -y"
alias install="sudo apt install"
alias remove="sudo apt remove"
alias purge="sudo apt purge"
alias autoremove="sudo apt autoremove"

# Path shortcuts
alias home="cd ~"
alias root="cd /"
alias dev="cd ~/dev"
alias docs="cd ~/Documents"

# File operations
alias cp="cp -i"                          # Confirm before overwriting
alias mv="mv -i"                          # Confirm before overwriting
alias rm="rm -i"                          # Confirm before removing

# Show directory size
alias dirsize="du -sh"

# Edit configuration files
alias vimrc="vim ~/.vimrc"
alias bashrc="vim ~/.bashrc"
alias zshrc="vim ~/.zshrc"
alias tmuxconf="vim ~/.tmux.conf"

# Quick reload of shell configuration
alias reload="source ~/.bashrc"
