#!/bin/bash
set -e

for file in .zshrc .vimrc .gitconfig .gitignore_global; do
    [ -f ~/$file ] && mv ~/$file ~/$file.bak
    cp $file ~/$file
done

echo "Done"