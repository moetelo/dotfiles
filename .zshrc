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

ZSH_THEME=telo
plugins=(sudo git)
source ~/.oh-my-zsh/oh-my-zsh.sh

zle -N clear-screen-and-scrollback
bindkey '^L' clear-screen-and-scrollback
bindkey '^H' backward-kill-word

export EDITOR='nvim'
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' list-prompt ''

source ~/scripts/proxy-utils.sh
source ~/scripts/fzf-utils.sh
source ~/scripts/think.sh

export ANDROID_HOME=/opt/android-sdk/
export PNPM_HOME="$HOME/.local/share/pnpm/"
export CARGO_HOME="$HOME/.cargo/bin/"
export BUN_INSTALL="$HOME/.bun"
export GO_BIN="$HOME/go/bin/"
path=("$HOME/scripts/bin/" "$HOME/.local/bin/" "$BUN_INSTALL/bin" $PNPM_HOME $CARGO_HOME $GO_BIN $path)
export PATH

[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

alias ls='ls --color=auto'
alias ll='ls -la'
alias grep='grep --color=auto'

sum-num() {
    declare nums=${*:-$(</dev/stdin)}
    echo $nums | paste -sd+ - | bc
}

alias config="/usr/bin/git --git-dir='$HOME/dotfiles' --work-tree=$HOME"


# fnm
FNM_PATH="/home/mikhail/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/mikhail/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
# . "/home/mikhail/.cargo/bin/env"


# bun completions
[ -s "/home/mikhail/.bun/_bun" ] && source "/home/mikhail/.bun/_bun"

