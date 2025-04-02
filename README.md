# Dotfiles

A collection of configuration files for a productive Unix/Linux development environment.

## Overview

These dotfiles provide a consistent and efficient setup across different machines, with support for both Linux and macOS environments. They include configurations for:

- Shell environments (Zsh with optional Oh-My-Zsh)
- Terminal multiplexer (Tmux)
- Text editors (Vim/Neovim)
- Version control (Git)
- Container tools (Docker, Kubernetes)
- Infrastructure as Code (Ansible, Terraform)

## Installation

```bash
git clone https://github.com/vegardkrogh/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

### Installation Options

- `-y` - Install dependencies automatically
- `-z` - Use Oh-My-Zsh (more features but slower)
- `-n` - Skip Oh-My-Zsh (faster, minimal setup)

## Quick Navigation

- **Installation**: Run `readme install` or `dotinstall` to view installation instructions
- **Configuration**: Run `readme config` or `dotconfig` to view configuration details
- **Cheatsheet**: Run `readme cheat` or `dotcheat` to view helpful shortcuts
- **Aliases**: Run `readme alias` or `dotaliases` to view all available aliases

## Key Features

- Starship or optional Powerlevel10k theme for a beautiful and informative prompt
- Lightweight ZSH setup (Oh-My-Zsh is optional)
- Simple prompt for VS Code terminals
- Automatic update checking in the background
- Useful aliases for Git, Docker, Kubernetes, and more
- Plugin system for enhanced functionality
- Intuitive keyboard shortcuts
- Built-in documentation system

## Documentation

This repository includes a built-in documentation tool. Simply run `readme` to access various parts of the documentation:

```bash
# General usage
readme [scope] --options

# Available scopes
# - general    (default, shows this README)
# - install    (installation instructions)
# - config     (configuration details)
# - cheat      (cheatsheet with shortcuts)
# - alias      (list of all aliases)

# Format options
# --format, -f: md|markdown, html, txt|text, trm|terminal
```

## Customization

These dotfiles are designed to be easily customizable. Add your own settings without modifying the core files:

- Create `~/.zshrc.local` for custom Zsh settings
- Create `~/.gitconfig.local` for custom Git settings

### VS Code Integration

To use the simple prompt in VS Code, add this to your VS Code settings:

```json
"terminal.integrated.env.osx": {
  "USE_SIMPLE_PROMPT": "1"
}
```

See `vscode_settings_example.json` for examples for all platforms.

## License

This project is open source and available under the MIT License.