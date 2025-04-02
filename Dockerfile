FROM debian:stable-slim

# Prevent prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Base layer - essential development tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    zsh \
    vim \
    neovim \
    tmux \
    fzf \
    ripgrep \
    fd-find \
    procps \
    htop \
    less \
    locales \
    sudo \
    build-essential \
    ca-certificates \
    gnupg \
    python3 \
    python3-pip \
    unzip \
    jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Generate locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Set up a non-root user with sudo permissions
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Copy installation and uninstallation scripts
COPY docker/scripts/ /opt/scripts/
RUN chmod +x /opt/scripts/*.sh

# Install Starship prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Set default shell to zsh
RUN chsh -s /usr/bin/zsh $USERNAME

# Switch to the non-root user
USER $USERNAME
WORKDIR /home/$USERNAME

# Create language environments directory
RUN mkdir -p /home/$USERNAME/.local/bin

# Clone dotfiles to temporary location (we'll move them during entry)
RUN git clone https://github.com/vegardkrogh/dotfiles.git /tmp/dotfiles

# Create entrypoint script
RUN echo '#!/bin/bash \n\
# If dotfiles don't exist in home directory, copy from temp location \n\
if [ ! -d "$HOME/.dotfiles" ]; then \n\
  cp -r /tmp/dotfiles $HOME/.dotfiles \n\
  cd $HOME/.dotfiles \n\
  ./install.sh -n -y \n\
fi \n\
# Ask about language setup if this is an interactive session \n\
if [ -t 0 ] && [ $# -eq 0 ]; then \n\
  /opt/scripts/devenv-manager.sh \n\
fi \n\
# Execute the provided command or start zsh \n\
if [ $# -eq 0 ]; then \n\
  exec zsh \n\
else \n\
  exec "$@" \n\
fi' > /home/$USERNAME/entrypoint.sh \
    && chmod +x /home/$USERNAME/entrypoint.sh

# Set default environment variables
ENV TERM=xterm-256color
ENV USE_SIMPLE_PROMPT=1
ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# Set the entrypoint
ENTRYPOINT ["/home/dev/entrypoint.sh"]