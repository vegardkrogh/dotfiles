# Docker Development Environment

This directory contains files for creating a Docker-based development environment with your dotfiles.

## Features

- Debian-based image with essential development tools
- Your dotfiles pre-installed
- Interactive menu to install/uninstall language environments:
  - Rust
  - Go
  - Node.js
  - Deno
  - Bun
  - Elixir
  - Python (advanced tools)
- Simple, clean terminal setup with Starship

## Usage

### Building the Image

```bash
cd ~/.dotfiles
docker build -t dotfiles-dev -f Dockerfile .
```

### Running the Container

```bash
# Interactive session with your dotfiles
docker run -it --rm dotfiles-dev

# Run a specific command
docker run -it --rm dotfiles-dev zsh -c "echo Hello from $(uname -a)"

# Mount a local directory for development
docker run -it --rm -v $(pwd):/workspace -w /workspace dotfiles-dev
```

### Environment Manager

When you start the container interactively, you'll be prompted to install language environments. You can also access this menu later by running:

```bash
/opt/scripts/devenv-manager.sh
```

## Customization

### Language Versions

You can update the language versions in the installation scripts:
- Rust: Always installs latest via rustup
- Go: Update GO_VERSION in `install-go.sh`
- Node.js: Update NODE_MAJOR in `install-node.sh`
- Others: Use the latest versions by default

### Adding More Languages

To add support for another language:
1. Create `install-{language}.sh` and `uninstall-{language}.sh` scripts in the `docker/scripts` directory
2. Update `devenv-manager.sh` to include the new language

## Advanced Uses

### Persistent Containers

For a persistent development environment:

```bash
docker run -it -v $(pwd):/workspace -v dotfiles-home:/home/dev --name my-dev-env dotfiles-dev
```

This creates a container with:
- Your current directory mounted at /workspace
- A Docker volume for the home directory to persist installed tools
- A name for easy restart: `docker start -ai my-dev-env`