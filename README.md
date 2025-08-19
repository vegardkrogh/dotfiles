# Dotfiles

A minimal, cross-platform dotfiles configuration for zsh, bash, vim, and tmux.

## Features

- **Zsh Configuration**: Fast and minimal zsh setup with useful defaults
- **Cross-Platform**: Works on macOS, Linux (Ubuntu/Debian), and WSL
- **Modular Design**: Easy to extend with private configurations
- **Simple Installation**: One-command setup

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/vegardkrogh/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

3. Restart your shell or source the new configuration:
   ```bash
   source ~/.zshrc
   ```

## Updating

To update your dotfiles, simply pull the latest changes and re-run the installation script:

```bash
cd ~/.dotfiles
git pull origin main
./install.sh
```

## Extending with Private Configurations

This repository is designed to work alongside private configurations. To extend it with your private settings:

1. Create a `~/.zshrc.private` file for your private configurations
2. Or create a separate private dotfiles repository and source it from `~/.zshrc.private`

## Included Components

- **Zsh**: Fast shell with useful aliases and completion
- **Vim**: Basic vim configuration with sensible defaults
- **Tmux**: Basic tmux configuration with prefix remapping
- **Bash**: Basic bash aliases and functions

## License

MIT