#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

export MONITOR=$(polybar -m | tail -1 | sed -e 's/:.*$//g')

# echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
# polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
# polybar example 2>&1 | tee -a /tmp/polybar2.log & disown
polybar main

echo "Polybar launched..."

