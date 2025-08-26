#!/bin/bash

# Setup script for dotfiles
# This handles the actual installation after repos are cloned

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Ensure line exists in file - adds if missing, doesn't duplicate
ensure_line() {
    local file="$1"
    local line="$2"
    local comment="$3"
    
    # Create file if it doesn't exist
    if [ ! -f "$file" ]; then
        touch "$file"
    fi
    
    # Check if line already exists
    if ! grep -Fxq "$line" "$file"; then
        # Add comment if provided
        if [ -n "$comment" ]; then
            echo "" >> "$file"
            echo "# $comment" >> "$file"
        fi
        echo "$line" >> "$file"
        echo -e "${GREEN}Added to $file: $line${NC}"
    else
        echo -e "${YELLOW}Already exists in $file: $line${NC}"
    fi
}

# Directories
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_PRIVATE_DIR="$HOME/.dotfiles-private"

# Parse arguments
INSTALL_PRIVATE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --private)
            INSTALL_PRIVATE=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

echo -e "${BLUE}==> Setting up dotfiles...${NC}"

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "  Symlink already exists: $target"
        return
    fi
    
    if [ -e "$target" ]; then
        echo "  Backing up existing file: $target"
        mv "$target" "$target.backup"
    fi
    
    echo "  Creating symlink: $target -> $source"
    ln -sfn "$source" "$target"
}

# Create necessary directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"

# Install base configuration from public dotfiles
echo -e "${BLUE}==> Installing base configuration...${NC}"

# Create symlinks for static config files (vim, tmux)
create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Use sourcing strategy for shell configs to prevent overwriting by tools
echo -e "${BLUE}==> Setting up shell configuration sourcing...${NC}"

# Source function for safe file loading
source_if_exists_func='
# Function to safely source files if they exist
source_if_exists() {
    [ -f "$1" ] && source "$1"
}'

# Add source function to .zshrc
ensure_line "$HOME/.zshrc" "$source_if_exists_func" "Dotfiles: Function to safely source files"

# Add sourcing lines for dotfiles
ensure_line "$HOME/.zshrc" "source_if_exists \"$DOTFILES_DIR/.zshrc\"" "Dotfiles: Source public dotfiles zsh config"
ensure_line "$HOME/.zshrc" "source_if_exists \"$DOTFILES_DIR/.bash_aliases\"" "Dotfiles: Source public dotfiles aliases"

# Install Starship config if it exists
if [ -f "$DOTFILES_DIR/.config/starship.toml" ]; then
    create_symlink "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
fi

# Install private configurations if requested
if [ "$INSTALL_PRIVATE" = true ] && [ -d "$DOTFILES_PRIVATE_DIR" ]; then
    echo -e "${BLUE}==> Installing private configurations...${NC}"
    
    # Link private configs (static files)
    if [ -f "$DOTFILES_PRIVATE_DIR/.gitconfig" ]; then
        create_symlink "$DOTFILES_PRIVATE_DIR/.gitconfig" "$HOME/.gitconfig"
    fi
    
    if [ -f "$DOTFILES_PRIVATE_DIR/.ssh/config" ]; then
        mkdir -p "$HOME/.ssh"
        create_symlink "$DOTFILES_PRIVATE_DIR/.ssh/config" "$HOME/.ssh/config"
        chmod 600 "$HOME/.ssh/config"
    fi
    
    # Add private dotfiles sourcing to .zshrc
    if [ -f "$DOTFILES_PRIVATE_DIR/.zshrc" ]; then
        ensure_line "$HOME/.zshrc" "source_if_exists \"$DOTFILES_PRIVATE_DIR/.zshrc\"" "Dotfiles: Source private dotfiles zsh config"
    fi
    
    if [ -f "$DOTFILES_PRIVATE_DIR/private-additions.zsh" ]; then
        ensure_line "$HOME/.zshrc" "source_if_exists \"$DOTFILES_PRIVATE_DIR/private-additions.zsh\"" "Dotfiles: Source private additions"
    fi
    
    echo "  Private configurations will be sourced from $DOTFILES_PRIVATE_DIR"
fi


# Install ZSH plugins
echo -e "${BLUE}==> Installing ZSH plugins...${NC}"
mkdir -p "$DOTFILES_DIR/.zsh/plugins"

# Install zsh-syntax-highlighting
if [ ! -d "$DOTFILES_DIR/.zsh/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "$DOTFILES_DIR/.zsh/plugins/zsh-syntax-highlighting"
fi

# Install zsh-autosuggestions
if [ ! -d "$DOTFILES_DIR/.zsh/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git \
        "$DOTFILES_DIR/.zsh/plugins/zsh-autosuggestions"
fi

# Install fzf-tab
if [ ! -d "$DOTFILES_DIR/.zsh/plugins/fzf-tab" ]; then
    git clone https://github.com/Aloxaf/fzf-tab.git \
        "$DOTFILES_DIR/.zsh/plugins/fzf-tab"
fi

# Install dependencies based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${BLUE}==> Checking Homebrew packages...${NC}"
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}Homebrew not found. Please install it first.${NC}"
    else
        # Install essential packages
        packages=(zsh vim tmux neovim fzf starship)
        for pkg in "${packages[@]}"; do
            if ! brew list "$pkg" &>/dev/null; then
                echo "  Installing $pkg..."
                brew install "$pkg"
            else
                echo "  $pkg already installed"
            fi
        done
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "${BLUE}==> Installing Linux packages...${NC}"
    # Add Linux package installation here
fi

echo -e "${GREEN}==> Setup complete!${NC}"