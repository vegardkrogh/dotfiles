# Base zsh configuration for public dotfiles
# This file contains only the most essential configurations that are safe to share publicly

# Disable compfix to avoid permission-related errors
ZSH_DISABLE_COMPFIX="true"

# Set up basic shell environment
export PATH="$HOME/.local/bin:$PATH"

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

# Load aliases if they exist
source_if_exists "$HOME/.bash_aliases"

# Simple prompt for VS Code or when explicitly requested
if [ "$USE_SIMPLE_PROMPT" = "1" ] || [ "$TERM_PROGRAM" = "vscode" ] || [ -n "$VSCODE" ]; then
  PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{blue}%~%f$ '
fi

# Load local configs if they exist
source_if_exists "$HOME/.zshrc.local"

# Export DOTFILES_DIR if not set (for public dotfiles)
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Source additional configurations from dotfiles if they exist
if [ -d "$DOTFILES_DIR" ]; then
  # Source additional zsh files from dotfiles
  for config_file in "$DOTFILES_DIR"/.zsh/conf.d/*.zsh; do
    source_if_exists "$config_file"
  done
  
  # Source public functions
  if [ -d "$DOTFILES_DIR/.zsh/functions" ]; then
    for func_file in "$DOTFILES_DIR"/.zsh/functions/*.zsh; do
      source_if_exists "$func_file"
    done
  fi
fi
