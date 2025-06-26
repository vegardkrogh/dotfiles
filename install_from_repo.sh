#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "📋 Installing configuration files..."

# Install dotfiles
for file in .zshrc .vimrc .gitconfig .gitignore_global; do
    if [ -f "$file" ]; then
        # Backup existing file
        if [ -f ~/$file ]; then
            mv ~/$file ~/$file.bak
            echo -e "  ${YELLOW}Backed up existing $file to $file.bak${NC}"
        fi
        cp "$file" ~/$file
        echo -e "  ${GREEN}✓ Installed $file${NC}"
    else
        echo -e "  ${YELLOW}⚠ $file not found in repository${NC}"
    fi
done

# Install nvim config if it exists
if [ -d "nvim" ]; then
    echo "📋 Installing Neovim configuration..."
    mkdir -p ~/.config
    if [ -d ~/.config/nvim ]; then
        mv ~/.config/nvim ~/.config/nvim.bak
        echo -e "  ${YELLOW}Backed up existing nvim config to nvim.bak${NC}"
    fi
    cp -r nvim ~/.config/
    echo -e "  ${GREEN}✓ Installed nvim config${NC}"
fi

# Install vim config if it exists
if [ -d "vim" ]; then
    echo "📋 Installing Vim configuration..."
    if [ -d ~/.vim ]; then
        mv ~/.vim ~/.vim.bak
        echo -e "  ${YELLOW}Backed up existing .vim to .vim.bak${NC}"
    fi
    cp -r vim ~/.vim
    echo -e "  ${GREEN}✓ Installed .vim directory${NC}"
fi

echo -e "\n${YELLOW}Note: Restart your terminal or run 'source ~/.zshrc' to apply changes${NC}"