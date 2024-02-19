#!/bin/env bash

think() {
    if [[ -z "$1" ]]; then
        $EDITOR $HOME/thoughts/$(date --iso-8601).md
        return
    fi

    if [[ -f "$HOME/thoughts/$1.md" ]]; then
        $EDITOR $HOME/thoughts/$1.md
        return
    fi

    # `think yesterday` support
    if [[ "$1" =~ "^[a-zA-Z ]+$" ]]; then
        fname=$(date --iso-8601 --date="$1")
        $EDITOR $HOME/thoughts/$fname.md
        return
    fi

    $EDITOR $HOME/thoughts/$1
}

previous-thought() {
    ls "$HOME/thoughts/" -1 | tail -2 | grep -v "$(date --iso-8601).md" | tail -1
}

think-move-unchecked() {
    local source_file="$HOME/thoughts/$(previous-thought)"
    local target_file="$HOME/thoughts/$(date --iso-8601).md"

    if [[ ! -f "$source_file" ]]; then
        echo "No file to migrate from."
        return 1
    fi

    touch "$target_file"
    echo "$target_file"

    # Find lines starting with '- [ ]' and move them to target file
    regex='\s*- \[ \].+((\n\s+).+)*'
    grep -Pzo "$regex" "$source_file" | tr -d '\000' >> "$target_file"
    perl -0777 -i -pe "s/$regex//g" "$source_file"
}

# compdef _think think

_think() {
    local -a files=(${HOME}/thoughts/*.md(:t:r))
    local -a options=('yesterday' 'tomorrow')

    _describe 'files' files
    _describe 'options' options
}

compdef _think think
