#!/bin/bash
# Test script for the VS Code prompt

# Export a variable to force simple prompt
export USE_SIMPLE_PROMPT=1

# Start a new ZSH instance with this variable
exec zsh -l