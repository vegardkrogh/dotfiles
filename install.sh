#!/bin/bash
# Dotfiles installation script - Works on both macOS and Linux
# but with configurations optimized for Linux environments

INSTALL_DEPENDENCIES=false

# Parse command opt -y
while getopts "y" opt; do
  case $opt in
    y)
      INSTALL_DEPENDENCIES=true
      ;;
    *)
      echo "Usage: $0 [-y]"
      echo "  -y  Install dependencies automatically"
      exit 1
      ;;
  esac
done

# Set colors for status messages
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print colored status messages
print_status() {
  echo -e "${BLUE}==>${NC} $1"
}

print_success() {
  echo -e "${GREEN}==>${NC} $1"
}

print_error() {
  echo -e "${RED}==>${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}==>${NC} $1"
}

# Detect operating system
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "linux"
  else
    echo "unknown"
  fi
}

OS=$(detect_os)
print_status "Detected OS: $OS"

# Check if this script is being run in a Docker container
is_in_container() {
  if [ -f /.dockerenv ] || grep -q 'docker\|lxc' /proc/1/cgroup 2>/dev/null; then
    return 0  # True, we are in a container
  else
    return 1  # False, not in a container
  fi
}

# Create necessary directories
mkdir -p ~/.config/git
mkdir -p ~/.local/bin

# Get the dotfiles directory (where this script is located)
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

print_status "Installing dotfiles from ${DOTFILES_DIR}"

# Check if we're in a Dev Container
in_devcontainer=false
if [ -n "$REMOTE_CONTAINERS" ] || [ -n "$CODESPACES" ] || [ -n "$VSCODE_REMOTE_CONTAINERS_SESSION" ] || is_in_container; then
  in_devcontainer=true
  print_status "Detected running in dev container"
fi

# Create symlinks for dotfiles
create_symlink() {
  local src="$1"
  local dest="$2"

  if [ -e "$dest" ]; then
    if [ -L "$dest" ]; then
      print_warning "Symlink already exists: $dest"
    else
      print_warning "Backing up existing file: $dest to $dest.backup"
      mv "$dest" "$dest.backup"
      ln -sf "$src" "$dest"
      print_success "Created symlink: $dest -> $src"
    fi
  else
    ln -sf "$src" "$dest"
    print_success "Created symlink: $dest -> $src"
  fi
}

# Create symlinks for all dotfiles
print_status "Creating symlinks for dotfiles..."
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/.bash_aliases" "$HOME/.bash_aliases"
create_symlink "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

# Setup utility scripts
print_status "Setting up utility scripts..."
if [ -d "$DOTFILES_DIR/.scripts" ]; then
  # Make scripts executable
  find "$DOTFILES_DIR/.scripts" -type f -name "*.py" -o -name "*.sh" | while read script; do
    chmod +x "$script"
    print_success "Made executable: $script"
  done

  # Create symlinks for utility scripts in ~/.local/bin
  for script in "$DOTFILES_DIR/.scripts"/*; do
    if [ -f "$script" ] && [ -x "$script" ]; then
      script_name=$(basename "$script")
      script_name_no_ext="${script_name%.*}"
      create_symlink "$script" "$HOME/.local/bin/$script_name_no_ext"
    fi
  done
else
  print_warning "Scripts directory not found. Skipping script setup."
fi

# Create global gitignore if it doesn't exist
if [ ! -f "$DOTFILES_DIR/.gitignore_global" ]; then
  print_status "Creating global gitignore..."
  cat > "$DOTFILES_DIR/.gitignore_global" << GITIGNORE
# macOS
.DS_Store
.AppleDouble
.LSOverride
._*

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini

# Linux
*~
.directory

# IDE files
.idea/
.vscode/
*.swp
*.swo
*~

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.env
.venv
env/
venv/
ENV/

# Node
node_modules/
npm-debug.log
yarn-error.log

# Ansible
*.retry
GITIGNORE

  create_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.config/git/ignore"
  if command -v git >/dev/null 2>&1; then
    git config --global core.excludesfile "$HOME/.config/git/ignore"
    print_success "Set git global excludes file"
  fi
fi

# Install dependencies based on OS
install_dependencies() {
  if [ "$OS" = "macos" ]; then
    print_status "Installing dependencies for macOS..."

    # Check if Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
      print_status "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      print_status "Homebrew already installed"
    fi

    # Install packages with Homebrew
    brew install zsh vim tmux neovim fzf
  elif [ "$OS" = "linux" ]; then
    print_status "Installing dependencies for Linux..."

    # Check package manager
    if command -v apt-get >/dev/null 2>&1; then
      print_status "Using apt package manager"
      sudo apt-get update
      sudo apt-get install -y zsh vim tmux neovim fzf curl git
    elif command -v dnf >/dev/null 2>&1; then
      print_status "Using dnf package manager"
      sudo dnf install -y zsh vim tmux neovim fzf curl git
    elif command -v yum >/dev/null 2>&1; then
      print_status "Using yum package manager"
      sudo yum install -y zsh vim tmux neovim fzf curl git
    elif command -v pacman >/dev/null 2>&1; then
      print_status "Using pacman package manager"
      sudo pacman -Sy zsh vim tmux neovim fzf curl git
    else
      print_warning "Unknown package manager. Please install dependencies manually."
    fi
  else
    print_warning "Unsupported OS. Please install dependencies manually."
  fi
}

# Ask user if they want to install dependencies
install_deps() {
  # In a container, we assume dependencies are already installed
  if [ "$in_devcontainer" = true ]; then
    print_status "Running in container, assuming dependencies are already installed"
    return
  fi

  if [ "$INSTALL_DEPENDENCIES" = true ]; then
    install_dependencies
  else
    read -p "Would you like to install dependencies? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_dependencies
  else
    print_status "Skipping dependency installation"
    fi
  fi
}

# Install oh-my-zsh if not already installed
install_omz() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    # Use -y to avoid the prompt that requires user input
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    print_success "Oh My Zsh installed"
  else
    print_status "Oh My Zsh already installed"
  fi
}

# Install powerlevel10k theme
install_p10k() {
  if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_status "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    print_success "Powerlevel10k installed"
  else
    print_status "Powerlevel10k already installed"
  fi
}

# Install zsh plugins
install_zsh_plugin() {
  local plugin_name="$1"
  local plugin_url="$2"
  local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"

  if [ ! -d "$plugin_dir" ]; then
    print_status "Installing $plugin_name..."
    git clone --depth=1 "$plugin_url" "$plugin_dir"
    print_success "$plugin_name installed"
  else
    print_status "$plugin_name already installed"
  fi
}

install_zsh_plugins() {
  install_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
  install_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
  install_zsh_plugin "fzf-tab" "https://github.com/Aloxaf/fzf-tab.git"
}

# Create documentation files
create_docs() {
  print_status "Creating documentation files..."

  # Create INSTALL.md if it doesn't exist
  if [ ! -f "$DOTFILES_DIR/INSTALL.md" ]; then
    cat > "$DOTFILES_DIR/INSTALL.md" << INSTALLMD
# Installation Guide

## Prerequisites

- Git
- Zsh (recommended)
- Bash (alternative)

## Quick Install

\`\`\`bash
git clone https://github.com/vegardkrogh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
\`\`\`

## Manual Installation

1. Clone this repository:
   \`\`\`bash
   git clone https://github.com/vegardkrogh/dotfiles.git ~/.dotfiles
   \`\`\`

2. Run the installation script:
   \`\`\`bash
   cd ~/.dotfiles
   ./install.sh
   \`\`\`

3. Restart your shell:
   \`\`\`bash
   exec zsh
   \`\`\`

## What's Included

- Zsh configuration with Oh-My-Zsh
- Powerlevel10k theme
- Useful plugins and aliases
- Tmux configuration
- Vim/Neovim setup
- Git configuration

## Troubleshooting

If you encounter any issues, please check the following:

1. Make sure all dependencies are installed
2. Verify that your shell is set to Zsh
3. Check for any error messages during installation
INSTALLMD
    print_success "Created INSTALL.md"
  fi

  # Create CONFIG.md if it doesn't exist
  if [ ! -f "$DOTFILES_DIR/CONFIG.md" ]; then
    cat > "$DOTFILES_DIR/CONFIG.md" << CONFIGMD
# Configuration Guide

## Zsh Configuration

The \`.zshrc\` file contains all the Zsh shell settings. Key settings include:

- Powerlevel10k theme configuration
- Plugin settings
- Aliases and functions
- Environment variables

## Custom Configuration

You can add your own custom configurations:

1. For Zsh, create a \`.zshrc.local\` file in your home directory
2. For Git, edit \`.gitconfig.local\`

## Available Tools

### Readme Tool

The \`readme\` command allows you to view documentation files:

\`\`\`bash
# View the main README
readme

# View installation instructions
readme install

# View configuration guide
readme config

# View cheatsheets
readme cheat

# View all defined aliases
readme alias

# Output in specific format
readme --format html
\`\`\`

### Alias Shortcuts

For quick access to documentation, you can use these aliases:

\`\`\`bash
dotdoc      # Show general documentation
dotinstall  # Show installation instructions
dotconfig   # Show configuration guide
dotcheat    # Show cheatsheet
dotaliases  # Show all defined aliases
dothelp     # Show documentation in terminal format
\`\`\`
CONFIGMD
    print_success "Created CONFIG.md"
  fi

  # Create CHEATSHEET.md if it doesn't exist
  if [ ! -f "$DOTFILES_DIR/CHEATSHEET.md" ]; then
    cat > "$DOTFILES_DIR/CHEATSHEET.md" << CHEATSHEETMD
# Cheatsheet

## Git Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| \`gs\` | \`git status\` | Check status |
| \`gco\` | \`git checkout\` | Checkout branch or files |
| \`gcm\` | \`git commit -m\` | Commit with message |
| \`gca\` | \`git commit --amend --no-edit\` | Amend commit without edit |
| \`gp\` | \`git push\` | Push to remote |
| \`gpl\` | \`git pull\` | Pull from remote |
| \`gb\` | \`git branch\` | List branches |
| \`gl\` | \`git log --oneline\` | View commit history |

## Docker Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| \`up\` | \`docker compose up\` | Start containers |
| \`down\` | \`docker compose down\` | Stop containers |
| \`ps\` | \`docker compose ps\` | List containers |
| \`logs\` | \`docker compose logs -f\` | Follow logs |

## Kubernetes Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| \`k\` | \`kubectl\` | Kubectl shorthand |

## Vim Cheatsheet

| Key | Action |
|-----|--------|
| \`dd\` | Delete line |
| \`yy\` | Copy line |
| \`p\` | Paste |
| \`u\` | Undo |
| \`Ctrl+r\` | Redo |
| \`/pattern\` | Search for pattern |
| \`:w\` | Save |
| \`:q\` | Quit |
| \`:wq\` | Save and quit |

## Tmux Cheatsheet

| Key | Action |
|-----|--------|
| \`Ctrl+b c\` | Create new window |
| \`Ctrl+b n\` | Next window |
| \`Ctrl+b p\` | Previous window |
| \`Ctrl+b %\` | Split vertically |
| \`Ctrl+b "\` | Split horizontally |
| \`Ctrl+b d\` | Detach from session |
CHEATSHEETMD
    print_success "Created CHEATSHEET.md"
  fi
}

# Create empty zshrc if it doesn't exist to avoid the zsh new user prompt
ensure_zshrc_exists() {
  if [ ! -f "$HOME/.zshrc" ]; then
    print_status "Creating empty .zshrc to avoid new user prompt..."
    touch "$HOME/.zshrc"
    print_success "Created empty .zshrc"
  fi
}

# Main installation process
main() {
  # Ensure zshrc exists first to prevent the new user prompt
  ensure_zshrc_exists

  # Ask about installing dependencies
  install_deps

  # Install Oh My Zsh
  install_omz

  # Install Powerlevel10k theme
  install_p10k

  # Install ZSH plugins
  install_zsh_plugins

  # Create documentation files
  create_docs

  # Install fzf
  if ! command -v fzf &> /dev/null; then
    print_status "Installing fzf..."
    if [ "$OS" = "macos" ]; then
      brew install fzf
      $(brew --prefix)/opt/fzf/install --all
    else
      if [ "$in_devcontainer" = false ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
      else
        print_status "Skipping fzf installation in container (assuming it's already installed)"
      fi
    fi
    print_success "fzf installed"
  else
    print_status "fzf already installed"
  fi

  print_success "Dotfiles installation complete!"
  print_status "Please restart your shell or run 'source ~/.zshrc'"
  print_status "Use 'readme' command to view documentation"
  print_status "Note: These dotfiles are optimized for Linux but should work on macOS as well"
}

# Run the main installation
main

