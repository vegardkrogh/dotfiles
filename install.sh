#!/bin/bash

# Public Dotfiles Installer  
# Can be run via: curl -fsSL https://raw.githubusercontent.com/vegardkrogh/dotfiles/main/install.sh | bash
# Or with flags: curl -fsSL ... | bash -s -- --private

VERSION="1.0.0"

set -e

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Public Dotfiles Installer v$VERSION"
        echo "Usage: $0 [options]"
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --version, -v  Show version"
        echo "  --dry-run      Show what would be installed without making changes"
        echo "  --private      Also install private dotfiles"
        exit 0
        ;;
    --version|-v)
        echo "$VERSION"
        exit 0
        ;;
    --dry-run)
        echo "DRY RUN: Would install public dotfiles to $HOME/.dotfiles"
        echo "DRY RUN: Would create symlinks for .zshrc, .vimrc, .tmux.conf, .bash_aliases"
        exit 0
        ;;
esac

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

# Update or add a line in .zshrc using a unique identifier
# This ensures clean updates without duplication
update_zshrc_line() {
    local line="$1"
    local identifier="$2"
    local zshrc="$HOME/.zshrc"
    
    # Create file if it doesn't exist
    if [ ! -f "$zshrc" ]; then
        touch "$zshrc"
    fi
    
    # Check if a line with this identifier exists
    if grep -q "#$identifier" "$zshrc"; then
        # Replace the entire line containing the identifier
        sed -i.bak "/#$identifier/c\\
$line #$identifier" "$zshrc"
        rm -f "$zshrc.bak"
        echo -e "${GREEN}Updated in ~/.zshrc: $line${NC}"
    else
        # Add the line to the file
        echo "$line #$identifier" >> "$zshrc"
        echo -e "${GREEN}Added to ~/.zshrc: $line${NC}"
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
ln -sf "$DOTFILES_DIR/.bash_aliases" "$HOME/.bash_aliases" && echo -e "${GREEN}✓ Linked .bash_aliases${NC}"

# Set up shell configuration sourcing
echo -e "${BLUE}==> Setting up shell configuration sourcing...${NC}"

# Add public dotfiles sourcing with unique identifier
update_zshrc_line "[ -f \"$DOTFILES_DIR/.zshrc\" ] && source \"$DOTFILES_DIR/.zshrc\"" "dotfiles-public"

# Add private dotfiles sourcing if installed
if [ "$INSTALL_PRIVATE" = true ] && [ -d "$DOTFILES_DIR-private" ]; then
    update_zshrc_line "[ -f \"$DOTFILES_DIR-private/.zshrc\" ] && source \"$DOTFILES_DIR-private/.zshrc\"" "dotfiles-private"
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