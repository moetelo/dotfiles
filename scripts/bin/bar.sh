#!/bin/bash

render() {
    local parts=()

    local volume=$(pactl get-sink-volume $(pactl get-default-sink) | awk 'NR==1{print $5}')
    local layout=$(xkblayout-state print "%s")
    local now=$(date +"%F %R")
    local bat=$(cat /sys/class/power_supply/BAT0/capacity)

    local voxtype_status=$(voxtype status --icon-theme nerd-font --format json --extended)
    local voxtype_status_alt=$(echo "$voxtype_status" | jq -r '.alt')

    if [[ "$voxtype_status_alt" != 'idle' ]]; then
        parts+=("$(echo "$voxtype_status" | jq -r '.model') $(echo "$voxtype_status" | jq -r '.text')")
    fi

    parts+=("󰁹 $bat%" "󰕾 $volume" "$layout" "$now")

    local result
    printf -v result ' | %s' "${parts[@]}"
    xsetroot -name "${result:3}"
}

xkb-switch -W \
    | while read -r _; do render; done &

pactl subscribe \
    | grep --line-buffered --fixed-strings 'sink' \
    | while read -r _; do render; done &

stdbuf -oL voxtype status --follow \
    | while read -r _; do render; done &

while true; do
    render
    sleep 20
done
