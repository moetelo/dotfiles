#!/bin/sh

render() {
    volume=$(pactl get-sink-volume $(pactl get-default-sink) | awk 'NR==1{print $5}')
    layout=$(xkblayout-state print "%s")
    now=$(date +"%F %R")
    bat=$(cat /sys/class/power_supply/BAT0/capacity)

    xsetroot -name "bat: $bat | vol: $volume | $layout | $now"
}

xkb-switch -W \
    | while read -r UNUSED_LINE; do render; done &

pactl subscribe \
    | grep --line-buffered "sink" \
    | while read -r UNUSED_LINE; do render; done &

while true; do
    render
    sleep 5
done
