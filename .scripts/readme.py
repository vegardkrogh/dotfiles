#! /usr/bin/env python3

# CLI for printing a dotfiles documentation
# - How to install
# - Configuration
# - Cheatsheets

# Usage:
# readme [scope] --options

# Scopes:
# install, installation
# config, configuration
# cheat, cheatsheets
# alias, aliases

# Options:
# --help, -h # Print help for the readme tool
# --format, -f # Format for the output
#    - md, markdown # Print in markdown format
#    - html, html # Print in html format
#    - txt, text # Print in text format
#    - trm, terminal # Print in terminal format (default)

# Examples:
# readme # prints README.md
# readme install # prints INSTALL.md
# readme alias # prints aliases from .bash_aliases

import argparse
import os
import sys
import re

def main():
    parser = argparse.ArgumentParser(
        description="Display README files with different scopes and formats",
        formatter_class=argparse.RawTextHelpFormatter
    )
    
    parser.add_argument(
        "scope", 
        nargs="?", 
        default="general", 
        help="Scope of the README (install, config, cheat, alias)"
    )
    
    parser.add_argument(
        "--format", "-f", 
        choices=["md", "markdown", "html", "txt", "text", "trm", "terminal"],
        default="terminal",
        help="Output format"
    )
    
    args = parser.parse_args()
    
    # Map scope aliases to file names
    scope_map = {
        "general": "README.md",
        "install": "INSTALL.md", 
        "installation": "INSTALL.md",
        "config": "CONFIG.md", 
        "configuration": "CONFIG.md",
        "cheat": "CHEATSHEET.md", 
        "cheatsheets": "CHEATSHEET.md"
    }
    
    # Special handling for aliases
    if args.scope.lower() in ["alias", "aliases"]:
        content = process_aliases()
        if not content:
            print("Could not find or parse .bash_aliases file")
            sys.exit(1)
    else:
        # Determine which file to read based on scope
        if args.scope.lower() in scope_map:
            filename = scope_map[args.scope.lower()]
        else:
            print(f"Unknown scope: {args.scope}")
            print("Available scopes: general, install, config, cheat, alias")
            sys.exit(1)
        
        # Try to find the file in the current directory or parent directories
        file_path = find_file(filename)
        
        if not file_path:
            print(f"Could not find {filename}")
            sys.exit(1)
        
        # Read the file content
        try:
            with open(file_path, 'r') as f:
                content = f.read()
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
            sys.exit(1)
    
    # Format and output the content
    output_format = args.format.lower()
    
    if output_format in ["md", "markdown"]:
        print(content)
    elif output_format in ["html"]:
        print(markdown_to_html(content))
    elif output_format in ["txt", "text"]:
        print(markdown_to_text(content))
    else:  # terminal format
        print(markdown_to_terminal(content))

def process_aliases():
    """Process .bash_aliases file and generate a markdown representation"""
    bash_aliases_path = find_file(".bash_aliases")
    
    if not bash_aliases_path:
        return None
    
    try:
        with open(bash_aliases_path, 'r') as f:
            alias_lines = f.readlines()
    except Exception:
        return None
    
    # Initialize markdown content with a header
    markdown = "# Bash Aliases\n\n"
    
    current_section = "General"
    
    for line in alias_lines:
        line = line.strip()
        
        # Skip empty lines
        if not line:
            continue
        
        # Check if this is a comment/section header
        if line.startswith("#"):
            # Use comments as section headers
            section_name = line.lstrip('#').strip()
            if section_name:
                current_section = section_name
                markdown += f"\n## {current_section}\n\n"
            continue
        
        # Parse alias definition
        if line.startswith("alias "):
            try:
                # Extract alias name and command
                # Format: "alias name=command"
                parts = line[6:].split("=", 1)
                if len(parts) == 2:
                    alias_name = parts[0].strip()
                    command = parts[1].strip()
                    
                    # Remove quotes if present
                    command = command.strip('"\'')
                    
                    # Extract comment if it exists
                    comment = ""
                    if "#" in command:
                        cmd_parts = command.split("#", 1)
                        command = cmd_parts[0].strip()
                        comment = cmd_parts[1].strip()
                    
                    # Add to markdown
                    markdown += f"- `{alias_name}` → `{command}`"
                    if comment:
                        markdown += f" - {comment}"
                    markdown += "\n"
            except Exception:
                # Skip malformed aliases
                continue
    
    return markdown

def find_file(filename, max_levels=3):
    """Search for a file in the current directory and parent directories"""
    current_dir = os.getcwd()
    
    for i in range(max_levels):
        file_path = os.path.join(current_dir, filename)
        
        if os.path.isfile(file_path):
            return file_path
        
        # Move up one directory
        parent_dir = os.path.dirname(current_dir)
        if parent_dir == current_dir:  # Reached root directory
            break
        current_dir = parent_dir
        
    # Also check in ~/.dotfiles if nothing found
    dotfiles_path = os.path.expanduser("~/.dotfiles")
    if os.path.isdir(dotfiles_path):
        file_path = os.path.join(dotfiles_path, filename)
        if os.path.isfile(file_path):
            return file_path
            
    # Also check in home directory for .bash_aliases specifically
    if filename == ".bash_aliases":
        home_path = os.path.expanduser("~")
        file_path = os.path.join(home_path, filename)
        if os.path.isfile(file_path):
            return file_path
            
    return None

def markdown_to_html(markdown_text):
    """Convert markdown to HTML (basic implementation)"""
    html = "<!DOCTYPE html>\n<html>\n<head>\n<style>\n"
    html += "body { font-family: sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }\n"
    html += "code { background-color: #f4f4f4; padding: 2px 4px; border-radius: 3px; }\n"
    html += "pre { background-color: #f4f4f4; padding: 10px; border-radius: 5px; overflow-x: auto; }\n"
    html += "</style>\n</head>\n<body>\n"
    
    # Convert headers
    markdown_text = re.sub(r'^# (.*?)$', r'<h1>\1</h1>', markdown_text, flags=re.MULTILINE)
    markdown_text = re.sub(r'^## (.*?)$', r'<h2>\1</h2>', markdown_text, flags=re.MULTILINE)
    markdown_text = re.sub(r'^### (.*?)$', r'<h3>\1</h3>', markdown_text, flags=re.MULTILINE)
    
    # Convert code blocks
    markdown_text = re.sub(r'```(.+?)```', r'<pre><code>\1</code></pre>', markdown_text, flags=re.DOTALL)
    
    # Convert inline code
    markdown_text = re.sub(r'`(.*?)`', r'<code>\1</code>', markdown_text)
    
    # Convert lists
    markdown_text = re.sub(r'^- (.*?)$', r'<li>\1</li>', markdown_text, flags=re.MULTILINE)
    
    # Convert paragraphs
    paragraphs = re.split(r'\n\n+', markdown_text)
    markdown_text = "\n".join([f"<p>{p}</p>" if not (p.startswith('<h') or p.startswith('<li') or p.startswith('<pre>')) else p for p in paragraphs])
    
    html += markdown_text
    html += "\n</body>\n</html>"
    return html

def markdown_to_text(markdown_text):
    """Convert markdown to plain text (basic implementation)"""
    # Remove code block markers
    text = re.sub(r'```.*?\n', '', markdown_text)
    text = re.sub(r'```', '', text)
    
    # Remove inline code markers
    text = re.sub(r'`(.*?)`', r'\1', text)
    
    return text

def markdown_to_terminal(markdown_text):
    """Convert markdown to terminal-friendly format with ANSI colors"""
    # ANSI color codes
    BOLD = "\033[1m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    MAGENTA = "\033[35m"
    CYAN = "\033[36m"
    RESET = "\033[0m"
    
    # Convert headers
    result = re.sub(r'^# (.*?)$', f'{BOLD}{RED}\\1{RESET}', markdown_text, flags=re.MULTILINE)
    result = re.sub(r'^## (.*?)$', f'{BOLD}{GREEN}\\1{RESET}', result, flags=re.MULTILINE)
    result = re.sub(r'^### (.*?)$', f'{BOLD}{YELLOW}\\1{RESET}', result, flags=re.MULTILINE)
    
    # Convert code blocks
    result = re.sub(r'```(.+?)```', f'{CYAN}\\1{RESET}', result, flags=re.DOTALL)
    
    # Convert inline code
    result = re.sub(r'`(.*?)`', f'{CYAN}\\1{RESET}', result)
    
    # Convert bullets
    result = re.sub(r'^- (.*?)$', f'{BLUE}•{RESET} \\1', result, flags=re.MULTILINE)
    
    return result

if __name__ == "__main__":
    main()

