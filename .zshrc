#!/bin/env bash

export LC_ALL=en_US.UTF-8

export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nvim'

ZSH_THEME="agnoster"
plugins=(sudo git proxy-toggle)
source $ZSH/oh-my-zsh.sh

bindkey '^H' backward-kill-word

alias ll='ls -la'

ng() {
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

adb-get-ip() {
    adb shell "ip addr show wlan0 | grep -e wlan0$ | cut -d\" \" -f 6 | cut -d/ -f 1"
}

adb-connect() {
    IP=$(adb-get-ip)
    echo $IP
    PORT=$(nmap $IP -p 37000-44000 | awk "/\/tcp/" | cut -d/ -f1)
    adb connect $IP:$PORT
}

source /usr/share/nvm/init-nvm.sh

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export LOCAL_BIN="$HOME/.local/bin/"
export PATH="$LOCAL_BIN:$PATH"

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias config="/usr/bin/git --git-dir='$HOME/dotfiles' --work-tree=$HOME"

