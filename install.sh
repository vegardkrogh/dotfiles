#!/bin/bash
set -e

# Auto-detect installation method
if [ -f ".gitconfig" ] && [ -f "install_from_repo.sh" ]; then
    # We're in the cloned repository
    echo "🔍 Detected local repository installation"
    bash install_from_repo.sh
elif [ -t 0 ]; then
    # Running interactively, not from pipe
    echo "❌ Not in a dotfiles repository. Please either:"
    echo "   1. Clone the repo first: git clone https://github.com/vegardkrogh/dotfiles.git && cd dotfiles && ./install.sh"
    echo "   2. Use curl for direct install: curl -fsSL https://raw.githubusercontent.com/vegardkrogh/dotfiles/main/install.sh | bash"
    exit 1
else
    # Running from pipe (curl | bash)
    echo "🔍 Detected curl installation"
    # Download and run the curl installer
    curl -fsSL https://raw.githubusercontent.com/vegardkrogh/dotfiles/main/install_from_curl.sh | bash
fi