#!/bin/bash

# Public dotfiles installation script
# This script sets up symlinks for the public dotfiles

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%s)"

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo -e "${YELLOW}Installing public dotfiles...${NC}"

# Function to create symlinks
link_file() {
  local src="$DOTFILES_DIR/$1"
  local dst="$2"
  
  # Create parent directory if it doesn't exist
  mkdir -p "$(dirname "$dst")"
  
  # Backup existing file if it exists and is not a symlink to our dotfiles
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ "$(readlink "$dst")" = "$src" ]; then
      echo "Symlink already exists: $dst"
      return 0
    fi
    echo "Backing up $dst to $BACKUP_DIR/"
    mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
  fi
  
  echo "Creating symlink: $dst -> $src"
  ln -s "$src" "$dst"
}

# Create symlinks for public dotfiles
link_file ".zshrc" "$HOME/.zshrc_public"
link_file ".bash_aliases" "$HOME/.bash_aliases"
link_file ".vimrc" "$HOME/.vimrc"
link_file ".tmux.conf" "$HOME/.tmux.conf"

# Create .zsh directory if it doesn't exist
mkdir -p "$HOME/.zsh"

# Create a minimal .zshrc that sources the public one
if [ ! -f "$HOME/.zshrc" ] || ! grep -q "source.*\.zshrc_public" "$HOME/.zshrc"; then
  echo -e "${YELLOW}Creating or updating ~/.zshrc to source public configuration${NC}"
  cat > "$HOME/.zshrc" << 'EOL'
# This file is managed by dotfiles installation script
# It sources the public dotfiles configuration

# Source public zshrc if it exists
if [ -f "$HOME/.zshrc_public" ]; then
  source "$HOME/.zshrc_public"
fi

# Source private zshrc if it exists
if [ -f "$HOME/.zshrc_private" ]; then
  source "$HOME/.zshrc_private"
fi

# Source local zshrc if it exists
if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi
EOL
fi

echo -e "\n${GREEN}Installation complete!${NC}"
echo -e "Your original files have been backed up to: $BACKUP_DIR"
echo -e "\nTo start using your new configuration, run:"
echo -e "  source ~/.zshrc"

# Check if we should source the new .zshrc
if [ "$1" = "--source" ]; then
  echo -e "\nSourcing ~/.zshrc..."
  source "$HOME/.zshrc"
  echo -e "${GREEN}Done! Your new shell configuration is now active.${NC}"
else
  echo -e "\nRun the following command to apply changes to your current shell:"
  echo -e "  source ~/.zshrc"
fi
