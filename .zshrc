#!/bin/env bash

export LC_ALL=en_US.UTF-8

export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nvim'

ZSH_THEME="agnoster"

if [ "$TERM" = "linux" ]; then
    ZSH_THEME="robbyrussell"
fi

plugins=(sudo git)
source $ZSH/oh-my-zsh.sh

source ~/scripts/proxy-utils.sh
source ~/scripts/adb-utils.sh
source ~/scripts/nnn-utils.sh

. /etc/profile.d/fzf.zsh
source ~/scripts/fzf-utils.sh

bindkey '^H' backward-kill-word

alias ll='ls -la'

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export CARGO_HOME="$HOME/.cargo/bin"
export LOCAL_BIN="$HOME/.local/bin/"
export PATH="$CARGO_HOME:$LOCAL_BIN:$PATH"

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias config="/usr/bin/git --git-dir='$HOME/dotfiles' --work-tree=$HOME"

