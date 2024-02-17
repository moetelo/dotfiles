#!/bin/env bash

export LC_ALL=en_US.UTF-8
export EDITOR='nvim'

ZSH_THEME="agnoster"

if [ "$TERM" = "linux" ]; then
    ZSH_THEME="robbyrussell"
fi

plugins=(sudo git)
source $HOME/.oh-my-zsh/oh-my-zsh.sh

source ~/scripts/proxy-utils.sh
source ~/scripts/adb-utils.sh
source ~/scripts/nnn-utils.sh
source ~/scripts/think.sh

source ~/scripts/fzf-utils.sh

export PNPM_HOME="$HOME/.local/share/pnpm/"
export CARGO_HOME="$HOME/.cargo/bin/"
export LOCAL_BIN="$HOME/.local/bin/"
export PATH="$PNPM_HOME:$CARGO_HOME:$LOCAL_BIN:$PATH"

bindkey '^H' backward-kill-word

alias ll='ls -la'
alias config="/usr/bin/git --git-dir='$HOME/dotfiles' --work-tree=$HOME"


