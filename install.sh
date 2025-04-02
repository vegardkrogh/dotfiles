#!/bin/bash
# Dotfiles installation script - Works on both macOS and Linux
# but with configurations optimized for Linux environments

INSTALL_DEPENDENCIES=false
USE_OMZ=false
SKIP_OMZ=false

# Parse command options
while getopts "yzn" opt; do
  case $opt in
    y)
      INSTALL_DEPENDENCIES=true
      ;;
    z)
      USE_OMZ=true
      ;;
    n)
      SKIP_OMZ=true
      ;;
    *)
      echo "Usage: $0 [-y] [-z] [-n]"
      echo "  -y  Install dependencies automatically"
      echo "  -z  Use Oh-My-Zsh (more features but slower)"
      echo "  -n  Skip Oh-My-Zsh (faster, minimal setup)"
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
mkdir -p ~/.config/starship

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

# Elixir
_build/
deps/

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

# Install Starship prompt
install_starship() {
  if ! command -v starship &> /dev/null; then
    print_status "Installing Starship prompt..."
    if [ "$OS" = "macos" ]; then
      brew install starship
    else
      curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi
    print_success "Starship prompt installed"
  else
    print_status "Starship prompt already installed"
  fi

  # Create Starship config directory if it doesn't exist
  mkdir -p "$HOME/.config"

  # Create symlink for Starship config
  if [ -f "$DOTFILES_DIR/.config/starship.toml" ]; then
    create_symlink "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
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

# Install zsh plugins directly (not via Oh-My-Zsh)
install_zsh_plugin() {
  local plugin_name="$1"
  local plugin_url="$2"
  local plugin_dir="$DOTFILES_DIR/.zsh/plugins/$plugin_name"

  if [ ! -d "$plugin_dir" ]; then
    print_status "Installing $plugin_name..."
    git clone --depth=1 "$plugin_url" "$plugin_dir"
    print_success "$plugin_name installed"
  else
    print_status "$plugin_name already installed"
  fi
}

install_zsh_plugins() {
  # Create the plugins directory
  mkdir -p "$DOTFILES_DIR/.zsh/plugins"
  
  # Install plugins
  install_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
  install_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
  install_zsh_plugin "fzf-tab" "https://github.com/Aloxaf/fzf-tab.git"
}

# Create documentation files
create_docs() {
  print_status "Documentation files already exist, skipping creation"
  # The MD files are not created anymore as they already exist elsewhere
}

# Create empty zshrc if it doesn't exist to avoid the zsh new user prompt
ensure_zshrc_exists() {
  if [ ! -f "$HOME/.zshrc" ]; then
    print_status "Creating empty .zshrc to avoid new user prompt..."
    touch "$HOME/.zshrc"
    print_success "Created empty .zshrc"
  fi
}

# Create the ZSH functions directory
setup_zsh_dirs() {
  print_status "Setting up ZSH directories..."
  mkdir -p "$DOTFILES_DIR/.zsh/functions"
  mkdir -p "$DOTFILES_DIR/.zsh/plugins"
  mkdir -p "$DOTFILES_DIR/.zsh/completions"
  print_success "ZSH directories created"
}

# Ask user about Oh-My-Zsh
ask_about_omz() {
  # If option -z or --no-omz is passed, skip Oh-My-Zsh
  if [ "$SKIP_OMZ" = true ]; then
    print_status "Skipping Oh-My-Zsh installation as requested"
    return 1
  fi
  
  if [ "$USE_OMZ" = true ]; then
    print_status "Installing Oh-My-Zsh as requested"
    return 0
  fi
  
  # In a container, skip the prompt
  if [ "$in_devcontainer" = true ]; then
    print_status "Running in container, using lightweight ZSH setup without Oh-My-Zsh"
    return 1
  fi
  
  # Ask user for preference
  read -p "Would you like to use Oh-My-Zsh? (slower but more features) [y/N]: " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Using Oh-My-Zsh setup"
    return 0
  else
    print_status "Using lightweight ZSH setup without Oh-My-Zsh"
    return 1
  fi
}

# Main installation process
main() {
  # Ensure zshrc exists first to prevent the new user prompt
  ensure_zshrc_exists

  # Ask about installing dependencies
  install_deps
  
  # Set up ZSH directories
  setup_zsh_dirs

  # Ask about Oh-My-Zsh
  if ask_about_omz; then
    # Install Oh My Zsh
    install_omz
    
    # Copy the Oh-My-Zsh version of .zshrc
    if [ -f "$DOTFILES_DIR/.zshrc_with_omz" ]; then
      print_status "Using Oh-My-Zsh version of .zshrc"
      cp "$DOTFILES_DIR/.zshrc_with_omz" "$DOTFILES_DIR/.zshrc"
    fi
    
    # Powerlevel10k is an option with Oh-My-Zsh
    # Uncomment to install Powerlevel10k
    # install_p10k
  fi

  # Install Starship prompt (modern, fast prompt)
  install_starship

  # Install ZSH plugins (directly, not via Oh-My-Zsh)
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

