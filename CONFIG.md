# Configuration Guide

## Zsh Configuration

The `.zshrc` file contains all the Zsh shell settings. Key settings include:

- Powerlevel10k theme configuration
- Plugin settings
- Aliases and functions
- Environment variables

## Custom Configuration

You can add your own custom configurations:

1. For Zsh, create a `.zshrc.local` file in your home directory
2. For Git, edit `.gitconfig.local`

## Directory Structure

```
~/.dotfiles/
├── .zshrc              # Zsh configuration
├── .vimrc              # Vim configuration
├── .tmux.conf          # Tmux configuration
├── .bash_aliases       # Common aliases for both Bash and Zsh
├── .p10k.zsh           # Powerlevel10k configuration
├── .scripts/           # Utility scripts
│   └── readme.py       # Documentation tool
├── README.md           # Main documentation
├── INSTALL.md          # Installation guide
├── CONFIG.md           # Configuration guide (this file)
└── CHEATSHEET.md       # Keyboard shortcuts and aliases
```

## Environment Setup

### Shell Environment

- The default shell is set to Zsh
- Oh-My-Zsh is used for plugin management
- Powerlevel10k provides the prompt theme

### PATH Configuration

Your PATH includes:

- `~/.local/bin` for user scripts
- Other standard paths

### Editor Configuration

The default editors are set to:

```bash
export EDITOR="nvim"
export VISUAL="nvim"
```

## Available Tools

### Readme Tool

The `readme` command allows you to view documentation files:

```bash
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
```

### Alias Shortcuts

For quick access to documentation, you can use these aliases:

```bash
dotdoc      # Show general documentation
dotinstall  # Show installation instructions
dotconfig   # Show configuration guide
dotcheat    # Show cheatsheet
dotaliases  # Show all defined aliases
dothelp     # Show documentation in terminal format
```

## Customization Tips

1. **Theme**: Modify Powerlevel10k settings with `p10k configure`
2. **Plugins**: Add/remove plugins in the `.zshrc` file
3. **Aliases**: Add custom aliases to `.bash_aliases` or `.zshrc.local`
4. **Functions**: Add custom functions to `.zsh_functions`

## Keeping Up to Date

To update your dotfiles:

```bash
cd ~/.dotfiles
git pull
./install.sh  # Re-run to update symlinks for any new files
``` 