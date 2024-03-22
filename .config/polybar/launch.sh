#!/usr/bin/env bash

polybar-msg cmd quit
killall -q polybar

export MONITOR=$(polybar -m | tail -1 | sed -e 's/:.*$//g')

polybar main

