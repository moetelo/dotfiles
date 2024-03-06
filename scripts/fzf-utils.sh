#!/bin/env bash

fzf-pacman-uninstaller() {
    pacman -Qeq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns
}

fzf-git-branch-deleter() {
    if [ -t 0 ]; then
        echo "This command should be used in a pipe."
        return 1
    fi

    local branches=$(</dev/stdin);

    if [ -z "$branches" ]; then
        echo "No branches to delete."
        return 1
    fi

    local default_branch="$(git config init.defaultBranch)"

    echo $branches \
        | fzf --multi --preview "git log origin/$default_branch..{1} --oneline --no-merges --first-parent" \
        | xargs -I {} git branch -D {}
}

fh() {
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

