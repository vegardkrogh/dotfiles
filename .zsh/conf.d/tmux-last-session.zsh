# Make `tmux a` (bare) target the session you last attached to, instead of
# letting tmux's resolver pick. tmux 3.x prefers an *unattached* session and
# breaks ties by pane-output activity, which is rarely what we want — if you
# have an already-attached session plus a quieter spare, the spare wins.
#
# Uses tmux's own #{session_last_attached} format — no state file, no hooks.
# Falls through to default tmux behavior if no server is running or anything
# else looks off. `tmux a -t X` is untouched (and updates last_attached for X,
# so the next bare `tmux a` lands on X).
tmux() {
  if [[ $# -eq 1 && ( "$1" == "a" || "$1" == "at" || "$1" == "attach" || "$1" == "attach-session" ) ]]; then
    local target
    target=$(command tmux list-sessions -F '#{session_last_attached} #{session_name}' 2>/dev/null \
      | sort -rn | awk 'NR==1{print $2}')
    if [[ -n "$target" ]]; then
      command tmux attach -t "=$target"
      return
    fi
  fi
  command tmux "$@"
}
