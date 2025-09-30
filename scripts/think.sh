#!/bin/bash

think() {
    if [[ -z "$1" ]]; then
        think-move-unchecked
        $EDITOR $HOME/thoughts/$(date --iso-8601).md
        return
    fi

    if [[ -f "$HOME/thoughts/$1.md" ]]; then
        $EDITOR $HOME/thoughts/$1.md
        return
    fi

    # relative date support: `think -1` -> think 1 day ago
    if [[ "$1" =~ "^[-0-9]+$" ]]; then
        fname=$(date --iso-8601 --date="$1 day")
        $EDITOR $HOME/thoughts/$fname.md
        return
    fi

    $EDITOR $HOME/thoughts/$1.md
}

previous-thought() {
    find "$HOME/thoughts" -name '*-*-*.md' -type f -printf "%f\n" | sort -n | tail -2 | grep --invert-match "$(date --iso-8601).md" | tail -1
}

think-move-unchecked() {
    local source_file="$HOME/thoughts/$(previous-thought)"
    local target_file="$HOME/thoughts/$(date --iso-8601).md"

    if [[ ! -f "$source_file" ]]; then
        echo "No file to migrate from."
        return
    fi

    # Find lines starting with '- [ ]' and move them to the target file
    local regex='\s*- \[ \].+((\n\s+).+)*'

    grep --perl-regexp --null-data --only-matching "$regex" "$source_file" | tr -d '\000' >> "$target_file"
    perl -0777 -i -pe "s/$regex//g" "$source_file"
}

#compdef think

_think() {
    local -a files=(${HOME}/thoughts/*.md(:t:r))
    local -a options=('yesterday' 'tomorrow')

    _describe 'files' files
    _describe 'options' options
}

compdef _think think
