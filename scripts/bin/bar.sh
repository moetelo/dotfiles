#!/bin/sh

render() {
    volume=$(pactl get-sink-volume $(pactl get-default-sink) | awk 'NR==1{print $5}')
    layout=$(xkblayout-state print "%s")
    now=$(date +"%F %R")

    xsetroot -name "vol: $volume | $layout | $now"
}

xkb-switch -W \
    | while read -r UNUSED_LINE; do render; done &


pactl subscribe \
    | grep --line-buffered "sink" \
    | while read -r UNUSED_LINE; do render; done &

while true; do
    render
    sleep 2
done
