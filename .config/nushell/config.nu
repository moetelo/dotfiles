#!/usr/bin/env nu

# help config nu

$env.config.buffer_editor = 'nvim'
$env.config.table.mode = 'compact'
$env.config.table.header_on_separator = true

$env.config.show_banner = false
$env.PROMPT_COMMAND_RIGHT = ''

source ~/.cache/carapace/init.nu

source ~/scripts/think.nu

def dot-env [...command: any] {
  with-env {
    GIT_DIR: $'($env.HOME)/dotfiles',
    GIT_WORK_TREE: $env.HOME,
  } {
    run-external ...$command
  }
}

alias gfa = git fetch --all --prune

let BUN_INSTALL = $"($env.HOME)/.bun"

$env.path ++= [
  '/opt/android-sdk/',
  $"($env.HOME)/.local/share/pnpm/",
  $"($env.HOME)/.cargo/bin/",
  $"($BUN_INSTALL)/bin",
  $"($env.HOME)/go/bin/",
]


def prompt-git-branch [] {
  let branch = (do -i { git rev-parse --abbrev-ref HEAD } | complete)
  if $branch.exit_code != 0 {
    return ""
  }

  let dirty = (do -i { git status --porcelain } | complete)
  if $dirty.exit_code == 0 and ($dirty.stdout | str trim | is-empty) {
    $"(ansi blue)(ansi yellow)($branch.stdout | str trim)(ansi reset)"
  } else {
    $"(ansi blue)(ansi yellow)($branch.stdout | str trim)(ansi reset)"
  }
}

def pwd-in-prompt [] {
  if ($env.PWD == $env.HOME) {
    return "~"
  }

  $env.PWD | path basename
}

def prompt [] {
  let cwd = (ansi cyan) + (pwd-in-prompt) + (ansi reset)
  let git = prompt-git-branch

  if ($git != "") {
    $"($cwd) ($git) "
  } else {
    $"($cwd) "
  }
}

$env.PROMPT_COMMAND = { prompt }

$env.PROMPT_INDICATOR = { ||
  if $env.LAST_EXIT_CODE == 0 {
    (ansi green) + "❯ "
  } else {
    (ansi red) + "❯ "
  }
}
