#!/bin/env bash

fzf-pacman-uninstall-list() {
    echo "$1" | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns
}

fzf-pacman-uninstaller() {
    packages=$(expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort --reverse | awk '{print $3}')
    fzf-pacman-uninstall-list "$packages"
}
