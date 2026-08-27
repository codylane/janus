FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive
ENV container=docker

# Install systemd and SSH
RUN apt-get update && \
    apt-get install -y \
    ack \
    curl \
    git  \
    make \
    neovim \
    rake \
    ruby \
    universal-ctags && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app && \
    cd /app && \
        git clone https://github.com/codylane/janus.git

RUN mkdir -p ~/nvim && \
    mkdir -p ~/.config/nvim && \
    ln -sf ~/.vimrc ~/nvim/init.vim && \
    ln -sf ~/.vimrc ~/.config/nvim/init.vim
