#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
killall -q polybar

export MONITOR=$(polybar -m | tail -1 | sed -e 's/:.*$//g')

polybar main

echo "Polybar launched..."

