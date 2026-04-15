# Public shell aliases
# Generic aliases safe for public sharing

# Claude CLI
alias ccd="claude code --dangerously-skip-permissions"
alias ccc="claude code -c"
alias ccdc="ccd -c"

# Host-local aliases (not tracked, survives dotfiles sync)
[ -f "$HOME/.bash_aliases.local" ] && source "$HOME/.bash_aliases.local"
