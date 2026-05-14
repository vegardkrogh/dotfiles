# Public shell aliases
# Generic aliases safe for public sharing

# Claude CLI
# Use bare `claude`, not `claude code` — the latter triggers the upstream
# "did you mean `claude`?" startup tip on every invocation.
alias ccd="claude --dangerously-skip-permissions"
alias ccc="claude -c"
alias ccdc="ccd -c"

# Codex CLI
alias cdxd="codex --dangerously-bypass-approvals-and-sandbox"

# Host-local aliases (not tracked, survives dotfiles sync)
[ -f "$HOME/.bash_aliases.local" ] && source "$HOME/.bash_aliases.local"
