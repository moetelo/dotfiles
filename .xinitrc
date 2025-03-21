#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi


setup_screen() {
    xlayoutdisplay --dpi 96
    $HOME/.fehbg
}

/usr/bin/pipewire &
/usr/bin/pipewire-pulse &
/usr/bin/wireplumber &

xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto

xinput set-prop "Logitech USB Receiver" "libinput Accel Speed" -1

numlockx on &
picom --daemon &

thunar --daemon &

greenclip daemon &
dunst &
unclutter &
/usr/lib/xfce-polkit/xfce-polkit &

~/scripts/bin/bar.sh &

setup_screen
exec dwm
