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

# Function to check GitHub SSH auth
check_github_auth() {
    echo -e "${BLUE}Checking GitHub SSH authentication...${NC}"
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        return 0
    else
        return 1
    fi
}

# Check if private requested but no auth
if [ "$INSTALL_PRIVATE" = true ]; then
    if ! check_github_auth; then
        echo -e "${RED}Error: GitHub SSH authentication required for private installation${NC}"
        echo "Please set up SSH keys with GitHub first:"
        echo "  https://docs.github.com/en/authentication/connecting-to-github-with-ssh"
        exit 1
    fi
fi

echo -e "${BLUE}==> Starting dotfiles installation...${NC}"

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

# Install private dotfiles if requested
if [ "$INSTALL_PRIVATE" = true ]; then
    if [ ! -d "$DOTFILES_DIR-private" ]; then
        echo -e "${BLUE}==> Cloning private dotfiles...${NC}"
        git clone "$DOTFILES_PRIVATE_REPO" "$DOTFILES_DIR-private"
    else
        echo -e "${BLUE}==> Updating private dotfiles...${NC}"
        cd "$DOTFILES_DIR-private" && git pull origin main
    fi
fi


# Run the setup script
echo -e "${BLUE}==> Running setup...${NC}"
cd "$DOTFILES_DIR"

# Run public setup
if [ -f "$DOTFILES_DIR/setup.sh" ]; then
    if [ "$INSTALL_PRIVATE" = true ]; then
        bash "$DOTFILES_DIR/setup.sh" --private
    else
        bash "$DOTFILES_DIR/setup.sh"
    fi
fi

# Run private setup if private is installed
if [ "$INSTALL_PRIVATE" = true ] && [ -d "$DOTFILES_DIR-private" ]; then
    if [ -f "$DOTFILES_DIR-private/setup-private.sh" ]; then
        echo -e "${BLUE}==> Running private setup...${NC}"
        bash "$DOTFILES_DIR-private/setup-private.sh"
    fi
fi

echo -e "${GREEN}==> Installation complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"

if [ "$INSTALL_PRIVATE" = true ]; then
    echo "  2. Private configurations have been installed"
fi