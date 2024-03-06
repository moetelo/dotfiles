#!/bin/env bash

source /usr/share/zsh/share/antigen.zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle wbingli/zsh-wakatime
export ZSH_WAKATIME_PROJECT_DETECTION=true

antigen theme geometry-zsh/geometry

antigen apply

zstyle ':completion::complete:*' gain-privileges 1

export LC_ALL=en_US.UTF-8
export EDITOR='nvim'

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

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
export FNM_BIN="$HOME/.local/share/fnm/"
export PATH="$FNM_BIN:$PNPM_HOME:$CARGO_HOME:$LOCAL_BIN:$PATH"

bindkey '^H' backward-kill-word

alias ll='ls -la'
alias config="/usr/bin/git --git-dir='$HOME/dotfiles' --work-tree=$HOME"
alias grep='grep --color=auto'

eval "`fnm env`"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

