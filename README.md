# dotfiles

## Quick Install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/vegardkrogh/dotfiles/main/install.sh | bash
```

## Manual Install

```bash
git clone https://github.com/vegardkrogh/dotfiles.git
cd dotfiles
./install.sh
```

## What's included

- `.zshrc` - Zsh configuration
- `.vimrc` - Vim configuration  
- `.gitconfig` - Git configuration
- `.gitignore_global` - Global gitignore
- `nvim/` - Neovim configuration (if present)
- `vim/` - Vim plugins directory (if present)

All existing files will be backed up with a `.bak` extension before installation.