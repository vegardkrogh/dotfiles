# Installation Guide

## Prerequisites

- Git
- Zsh (recommended)
- Bash (alternative)

## Quick Install

```bash
git clone https://github.com/vegardkrogh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/vegardkrogh/dotfiles.git ~/.dotfiles
   ```

2. Run the installation script:
   ```bash
   cd ~/.dotfiles
   ./install.sh
   ```

3. Restart your shell:
   ```bash
   exec zsh
   ```

## What's Included

- Zsh configuration (with optional Oh-My-Zsh)
- Starship prompt (or optional Powerlevel10k theme)
- Useful plugins and aliases
- Tmux configuration
- Vim/Neovim setup
- Git configuration
- Documentation tool (`readme` command)

## Installation Options

The installation script accepts the following options:

- `-y` - Install dependencies automatically
- `-z` - Use Oh-My-Zsh (more features but slower)
- `-n` - Skip Oh-My-Zsh (faster, minimal setup)

If no options are specified, the script will ask if you want to:

1. Install dependencies (Zsh, Tmux, Vim, etc.)
2. Use Oh-My-Zsh or a lightweight ZSH setup

You can choose to skip any of these steps if you already have them installed or prefer to install them manually.

## Post-Installation

After installation:

1. Your old configuration files will be backed up with a `.backup` extension
2. New symlinks will be created in your home directory
3. Utility scripts will be symlinked to `~/.local/bin`

## Troubleshooting

If you encounter any issues, please check the following:

1. Make sure all dependencies are installed
2. Verify that your shell is set to Zsh (`echo $SHELL`)
3. Check for any error messages during installation
4. Ensure your `~/.local/bin` directory is in your PATH

## Uninstalling

To uninstall, run:

```bash
cd ~/.dotfiles
./uninstall.sh  # If available, or manually restore your .backup files
``` 