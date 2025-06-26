#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🚀 Installing dotfiles via curl..."

# Create temporary directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Clone the repository
echo "📦 Cloning dotfiles repository..."
git clone --depth=1 https://github.com/vegardkrogh/dotfiles.git "$TMP_DIR" 2>/dev/null || {
    echo -e "${RED}Failed to clone repository${NC}"
    exit 1
}

# Run install from repo
cd "$TMP_DIR"
if [ -f "install_from_repo.sh" ]; then
    bash install_from_repo.sh
else
    echo -e "${RED}install_from_repo.sh not found in repository${NC}"
    exit 1
fi

echo -e "\n${GREEN}✅ Dotfiles installation complete!${NC}"