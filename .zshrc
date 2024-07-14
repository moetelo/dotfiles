#!/bin/env bash

source /usr/share/zsh/share/antigen.zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle wbingli/zsh-wakatime
export ZSH_WAKATIME_PROJECT_DETECTION=true
antigen apply

zstyle ':completion::complete:*' gain-privileges 1

export EDITOR='nvim'

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

ZSH_THEME=telo
plugins=(sudo git)
source $HOME/.oh-my-zsh/oh-my-zsh.sh

source ~/scripts/proxy-utils.sh
source ~/scripts/adb-utils.sh
source ~/scripts/nnn-utils.sh
source ~/scripts/youtrack-pr.sh
source ~/scripts/think.sh

source ~/scripts/fzf-utils.sh

source ~/scripts/zsh-completion/symfony.sh

export PNPM_HOME="$HOME/.local/share/pnpm/"
export CARGO_HOME="$HOME/.cargo/bin/"
export LOCAL_BIN="$HOME/.local/bin/"
export FNM_BIN="$HOME/.local/share/fnm/"
export SCRIPTS_BIN="$HOME/scripts/bin/"
export PATH="$SCRIPTS_BIN:$FNM_BIN:$PNPM_HOME:$CARGO_HOME:$LOCAL_BIN:$PATH"

bindkey '^H' backward-kill-word

alias ll='ls -la'
alias config="/usr/bin/git --git-dir='$HOME/dotfiles' --work-tree=$HOME"
alias grep='grep --color=auto'
alias php='php-legacy'
alias phpize='phpize-legacy'

eval "`fnm env`"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# tabtab source for packages
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true


# bun completions
[ -s "/home/mikhail/.bun/_bun" ] && source "/home/mikhail/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
