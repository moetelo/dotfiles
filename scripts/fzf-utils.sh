#!/bin/env bash

fzf-pacman-uninstaller() {
    pacman -Qeq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns
}

