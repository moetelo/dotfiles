#!/bin/bash

render() {
    local parts=()

    local volume=$(pactl get-sink-volume $(pactl get-default-sink) | awk 'NR==1{print $5}')
    local layout=$(xkblayout-state print "%s")
    local now=$(date +"%F %R")
    local bat=$(cat /sys/class/power_supply/BAT0/capacity)

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

while true; do
    render
    sleep 20
done
