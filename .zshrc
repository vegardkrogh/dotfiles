# Simple .zshrc without Oh-My-Zsh dependencies
# Disable compfix to avoid errors
ZSH_DISABLE_COMPFIX="true"

# Dotfiles directory
export DOTFILES_DIR="$HOME/.dotfiles"

# Set up basic shell environment
export PATH=$HOME/.local/bin:$PATH
export EDITOR="nvim"
export VISUAL="nvim"

# Load dotfiles update system
source "$DOTFILES_DIR/.zsh/functions/dotfiles_update.zsh"

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

# Load plugin files if they exist (from custom location)
source_if_exists "$DOTFILES_DIR/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source_if_exists "$DOTFILES_DIR/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source_if_exists "$DOTFILES_DIR/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

# Load aliases
source_if_exists "$DOTFILES_DIR/.bash_aliases"

# Load custom functions
source_if_exists "$DOTFILES_DIR/.zsh/functions/zsh_functions.zsh"

# Load local configs if they exist
source_if_exists "$HOME/.zshrc.local"

# Initialize Starship prompt if installed (only when not in VS Code)
# Create a debug function to help diagnose
debug_info() {
  echo "TERM_PROGRAM: $TERM_PROGRAM"
  echo "VSCODE: $VSCODE"
  echo "Current prompt: $PROMPT"
}

# Simple function to detect if we're in VS Code
in_vscode() {
  # Hard-code simple prompt for VS Code, since detection isn't working reliably
  if [ "$USE_SIMPLE_PROMPT" = "1" ]; then
    return 0
  fi
  if [ "$TERM_PROGRAM" = "vscode" ]; then
    return 0
  fi
  if [ -n "$VSCODE" ]; then
    return 0
  fi
  return 1
}

# Set the prompt based on environment
if command -v starship &> /dev/null && ! in_vscode; then
  eval "$(starship init zsh)"
else
  # Simple prompt for VS Code
  PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{blue}%~%f$ '
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Claude CLI
alias claude="$HOME/.claude/local/claude"

# Initialize dotfiles update system
dotfiles_init