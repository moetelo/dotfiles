#!/bin/sh

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    echo exec startx
fi
