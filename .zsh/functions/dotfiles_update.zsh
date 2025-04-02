#!/usr/bin/env zsh
# Dotfiles update check mechanism that doesn't slow down shell startup

# Set dotfiles paths
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_UPDATE_FLAG="$HOME/.dotfiles_update_needed"

# Function to check for updates (runs in background)
dotfiles_check_update() {
  # Exit if not a git repo
  if [ ! -d "$DOTFILES_DIR/.git" ]; then
    return 1
  fi

  # Change to dotfiles directory
  cd "$DOTFILES_DIR" >/dev/null 2>&1 || return 1
  
  # Fetch from remote silently
  git fetch origin main --quiet >/dev/null 2>&1
  
  # Check if we're behind the remote
  local behind_count=$(git rev-list --count HEAD..origin/main 2>/dev/null)
  
  # If we're behind, create the update flag file with commit info
  if [ -n "$behind_count" ] && [ "$behind_count" -gt 0 ]; then
    # Get the latest commits we're missing (max 3)
    local latest_commits=$(git log --oneline --max-count=3 HEAD..origin/main 2>/dev/null)
    # Write to update flag file
    echo "$behind_count" > "$DOTFILES_UPDATE_FLAG"
    echo "$latest_commits" >> "$DOTFILES_UPDATE_FLAG"
  else
    # Delete the flag file if it exists and we're up to date
    rm -f "$DOTFILES_UPDATE_FLAG" 2>/dev/null
  fi
  
  # Return to original directory
  cd - >/dev/null 2>&1
  return 0
}

# Apply updates when requested
dotfiles_update() {
  if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo "Error: Dotfiles directory is not a git repository."
    return 1
  fi

  cd "$DOTFILES_DIR" >/dev/null 2>&1 || return 1
  
  # Pull latest changes
  echo "📦 Updating dotfiles..."
  git pull origin main
  
  # Run install script
  echo "🔄 Running install script..."
  bash "$DOTFILES_DIR/install.sh"
  
  # Remove update flag
  rm -f "$DOTFILES_UPDATE_FLAG" 2>/dev/null
  
  cd - >/dev/null 2>&1
  echo "✅ Dotfiles update complete!"
  
  return 0
}

# Check if update is available and show message
dotfiles_show_update_message() {
  # Skip if disabled via env var
  if [ -n "$DISABLE_DOTFILES_UPDATE_MESSAGE" ]; then
    return 1
  fi
  
  # Check if update flag exists
  if [ -f "$DOTFILES_UPDATE_FLAG" ]; then
    local behind_count=$(head -n 1 "$DOTFILES_UPDATE_FLAG")
    local latest_commits=$(tail -n +2 "$DOTFILES_UPDATE_FLAG")
    
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║ 📢 Dotfiles update available ($behind_count commit(s) behind)            ║"
    echo "╠════════════════════════════════════════════════════════════╣"
    echo "║ Latest changes:                                            ║"
    while IFS= read -r line; do
      printf "║ %-58s ║\n" "$line"
    done <<< "$latest_commits"
    echo "╠════════════════════════════════════════════════════════════╣"
    echo "║ Run 'dotfiles_update' to apply updates                     ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    return 0
  fi
  
  return 1
}

# Start background update check
dotfiles_start_background_check() {
  (dotfiles_check_update &) >/dev/null 2>&1
}

# Initialize the system (called from .zshrc)
dotfiles_init() {
  # Check for updates now (only if flag exists)
  dotfiles_show_update_message
  
  # Start background check for next time
  dotfiles_start_background_check
}