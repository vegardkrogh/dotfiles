#!/bin/bash

# Public Dotfiles Installer
# Can be run via: curl -fsSL https://raw.githubusercontent.com/vegardkrogh/dotfiles/main/install.sh | bash
# Or with flags: curl -fsSL ... | bash -s -- --private

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
DOTFILES_PUBLIC_REPO="https://github.com/vegardkrogh/dotfiles.git"
DOTFILES_PRIVATE_REPO="git@github.com:vegardkrogh/dotfiles-private.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Parse arguments
INSTALL_PRIVATE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --private)
            INSTALL_PRIVATE=true
            shift
            ;;
        --help)
            echo "Dotfiles Installer"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --private    Install private dotfiles (requires GitHub SSH auth)"
            echo "  --help       Show this help message"
            echo ""
            echo "Examples:"
            echo "  # Install only public dotfiles"
            echo "  curl -fsSL https://raw.githubusercontent.com/vegardkrogh/dotfiles/main/install.sh | bash"
            echo ""
            echo "  # Install with private configs"
            echo "  curl -fsSL https://raw.githubusercontent.com/vegardkrogh/dotfiles/main/install.sh | bash -s -- --private"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

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

# Check GitHub SSH authentication for private repos
check_github_auth() {
    ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"
}

echo -e "${BLUE}🚀 Installing dotfiles...${NC}"

# Check for required tools
command -v git >/dev/null 2>&1 || { 
    echo -e "${RED}git is required but not installed. Please install git first.${NC}" >&2
    exit 1
}

# Install public dotfiles
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${BLUE}==> Cloning public dotfiles...${NC}"
    git clone "$DOTFILES_PUBLIC_REPO" "$DOTFILES_DIR"
else
    echo -e "${BLUE}==> Updating public dotfiles...${NC}"
    cd "$DOTFILES_DIR" && git pull origin main
fi

# Check if private requested but no auth
if [ "$INSTALL_PRIVATE" = true ]; then
    if ! check_github_auth; then
        echo -e "${RED}Error: GitHub SSH authentication required for private installation${NC}"
        echo "Please set up SSH keys with GitHub first:"
        echo "  https://docs.github.com/en/authentication/connecting-to-github-with-ssh"
        exit 1
    fi
    
    # Install private dotfiles
    if [ ! -d "$DOTFILES_DIR-private" ]; then
        echo -e "${BLUE}==> Cloning private dotfiles...${NC}"
        git clone "$DOTFILES_PRIVATE_REPO" "$DOTFILES_DIR-private"
    else
        echo -e "${BLUE}==> Updating private dotfiles...${NC}"
        cd "$DOTFILES_DIR-private" && git pull origin main && cd "$DOTFILES_DIR"
    fi
fi

echo -e "${BLUE}==> Setting up configuration...${NC}"

# Create necessary directories
mkdir -p "$HOME/.config"

# Create symlinks for static config files
echo -e "${BLUE}==> Creating symlinks for config files...${NC}"
ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc" && echo -e "${GREEN}✓ Linked .vimrc${NC}"
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf" && echo -e "${GREEN}✓ Linked .tmux.conf${NC}"

# Set up shell configuration sourcing
echo -e "${BLUE}==> Setting up shell configuration sourcing...${NC}"

# Source function for safe file loading
source_if_exists_func='# Function to safely source files if they exist
source_if_exists() {
    [ -f "$1" ] && source "$1"
}'

# Add source function to .zshrc
ensure_line "$HOME/.zshrc" "$source_if_exists_func" "Dotfiles: Function to safely source files"

# Add sourcing line for aliases
ensure_line "$HOME/.zshrc" "source_if_exists \"$DOTFILES_DIR/.bash_aliases\"" "Dotfiles: Source public dotfiles aliases"

# Add private dotfiles sourcing if installed
if [ "$INSTALL_PRIVATE" = true ] && [ -d "$DOTFILES_DIR-private" ]; then
    ensure_line "$HOME/.zshrc" "source_if_exists \"$DOTFILES_DIR-private/.zshrc\"" "Dotfiles: Source private dotfiles"
fi

echo -e "${GREEN}==> Installation complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Your ~/.zshrc is now tool-safe and won't be overwritten by updates"
echo ""
if [ "$INSTALL_PRIVATE" != true ]; then
    echo "To install private configurations later:"
    echo "  curl -fsSL https://raw.githubusercontent.com/vegardkrogh/dotfiles/main/install.sh | bash -s -- --private"
fi