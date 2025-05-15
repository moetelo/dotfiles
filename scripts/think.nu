#!/usr/bin/env nu

def edit [file: string] {
    let EDITOR = $env.config.buffer_editor
    run-external $EDITOR $file
}

def thought-by-date [date: datetime] {
    $'($env.HOME)/thoughts/($date | format-iso-date).md'
}

def format-iso-date [] {
    each { |date| $date | format date '%Y-%m-%d' }
}

def "think yesterday" [] {
    edit (thought-by-date ((date now) - 1day))
}

def daily-thoughts [] {
    glob ~/thoughts/*.md | where $it =~ '\d{4}-\d{2}-\d{2}.md' | sort
}

def daily-thoughts-basename [] {
    daily-thoughts | path basename
}

def previous-thought [] {
    daily-thoughts | last 2 | where $it !~ $'(date now | format-iso-date).md$' | last
}

def think-move-unchecked [] {
    let sourceFile = (previous-thought)
    let targetFile = (thought-by-date (date now))

    if (not ($sourceFile | path exists)) {
        print "No file to migrate from."
        return
    }

    # Find lines starting with '- [ ]' and move them to the target file
    let regex = '\s*- \[ \].+((\n\s+).+)*'

    grep --perl-regexp --null-data --only-matching $regex $sourceFile | tr -d '\000' out>> $targetFile
    perl -0777 -i -pe $"s/($regex)//g" $sourceFile
}

def think [isoDateMd?: string@daily-thoughts-basename] {
    if ($isoDateMd | is-empty) {
        think-move-unchecked
        edit (thought-by-date (date now))
        return
    }

    edit $'($env.HOME)/thoughts/($isoDateMd)'
}
