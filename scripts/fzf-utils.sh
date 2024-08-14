#!/bin/env bash

fzf-pacman-uninstall-list() {
    echo "$1" | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns
}

fzf-pacman-uninstaller() {
    # packages=$(expac --timefmt='%Y-%m-%d %T' '%l\t%n' | grep -F "$(pacman -Qeq)" | sort --reverse | awk '{print $3}')
    packages=$(expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort --reverse | awk '{print $3}')
    fzf-pacman-uninstall-list "$packages"
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

