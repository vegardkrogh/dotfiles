# Base zsh configuration for public dotfiles
# This file contains only the most essential configurations that are safe to share publicly

# Disable compfix to avoid permission-related errors
ZSH_DISABLE_COMPFIX="true"

# Set up basic shell environment
export PATH="$HOME/.local/bin:/venv/bin:$PATH"

# Set default editor (nvim > vim > vi)
if command -v nvim &> /dev/null; then
  export EDITOR="nvim"
  export VISUAL="nvim"
elif command -v vim &> /dev/null; then
  export EDITOR="vim"
  export VISUAL="vim"
else
  export EDITOR="vi"
  export VISUAL="vi"
fi

# Ansible-vault edits decrypt to ~/.ansible/tmp/*.yml and open in $EDITOR;
# nvim/vim persist that content into shada (registers/history) and undo files
# unless explicitly suppressed. Disable all persistence for vault sessions
# only — normal editing keeps shada/undo. Enforced by CON-SWM-051.
if [[ "$EDITOR" == "nvim" || "$EDITOR" == "vim" ]]; then
  export ANSIBLE_VAULT_EDITOR="$EDITOR -i NONE -n -c 'set noundofile noswapfile'"
fi

# Source function to safely load files
source_if_exists() {
  [ -f "$1" ] && source "$1"
}

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

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
compinit -i
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Enable keyboard shortcuts
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^H' backward-delete-char

# Basic aliases
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

# Load additional aliases if they exist
source_if_exists "$HOME/.bash_aliases"

# Prompt configuration
if [ "$USE_SIMPLE_PROMPT" = "1" ] || [ "$TERM_PROGRAM" = "vscode" ] || [ -n "$VSCODE" ]; then
  # Simple prompt for VS Code
  PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{blue}%~%f$ '
else
  # Use Starship if available, otherwise use a nice fallback
  if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
  else
    PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{blue}%~%f$ '
  fi
fi


# Load local configs if they exist  
source_if_exists "$HOME/.zshrc.local"

# Export DOTFILES_DIR if not set (for public dotfiles)
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# zsh plugins (zsh-syntax-highlighting, zsh-autosuggestions, fzf-tab) moved
# to private dotfiles tier — they're personal, not part of the shareable
# bones. Private .zshrc handles sourcing.

# FZF configuration
if command -v fzf &> /dev/null; then
  export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
  source_if_exists /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source_if_exists /opt/homebrew/opt/fzf/shell/completion.zsh
  source_if_exists /usr/share/fzf/key-bindings.zsh
  source_if_exists /usr/share/fzf/completion.zsh
fi

# Source additional configurations from dotfiles if they exist
if [ -d "$DOTFILES_DIR" ]; then
  # Source additional zsh files from dotfiles (only if directory exists)
  if [ -d "$DOTFILES_DIR/.zsh/conf.d" ]; then
    for config_file in "$DOTFILES_DIR"/.zsh/conf.d/*.zsh; do
      [ -f "$config_file" ] && source_if_exists "$config_file"
    done
  fi
  
  # Source public functions (only if directory exists)
  if [ -d "$DOTFILES_DIR/.zsh/functions" ]; then
    for func_file in "$DOTFILES_DIR"/.zsh/functions/*.zsh; do
      [ -f "$func_file" ] && source_if_exists "$func_file"
    done
  fi
fi

# Bun completions (if installed)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Bun path (if installed)
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

echo "dotfiles loaded from $DOTFILES_DIR"