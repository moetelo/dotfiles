#!/bin/env bash

autoload -Uz compinit; compinit -C
# Have another thread refresh the cache in the background (subshell to hide output)
(autoload -Uz compinit; compinit &)

ZSH_PLUGINS=/usr/share/zsh/plugins
source $ZSH_PLUGINS/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

clear-screen-and-scrollback() {
    printf '\x1Bc'
    zle clear-screen
}

zle -N clear-screen-and-scrollback
bindkey '^L' clear-screen-and-scrollback
bindkey '^H' backward-kill-word

ZSH_THEME=telo
plugins=(sudo git)
source ~/.oh-my-zsh/oh-my-zsh.sh

export EDITOR='nvim'
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' list-prompt ''

source ~/scripts/proxy-utils.sh
source ~/scripts/fzf-utils.sh
source ~/scripts/runit-utils.sh
source ~/scripts/think.sh

export PNPM_HOME="$HOME/.local/share/pnpm/"
export CARGO_HOME="$HOME/.cargo/bin/"
export BUN_INSTALL="$HOME/.bun"
path=("$HOME/scripts/bin/" "~/.local/bin/" "$BUN_INSTALL/bin" $PNPM_HOME $CARGO_HOME $path)
export PATH

[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

alias ls='ls --color=auto'
alias ll='ls -la'
alias config="/usr/bin/git --git-dir='$HOME/dotfiles' --work-tree=$HOME"
alias grep='grep --color=auto'
