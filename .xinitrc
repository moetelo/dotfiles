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

enable_wifi() {
    iwctl adapter phy0 set-property Powered on
    iwctl device wlan0 set-property Powered on
}

/usr/bin/pipewire &
/usr/bin/pipewire-pulse &
/usr/bin/wireplumber &
enable_wifi &

# x
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto

xinput --set-prop "Logitech USB Receiver" "libinput Accel Speed" -1

numlockx on &
picom -b &

setup_screen &
greenclip daemon &
dunst &
solaar --window=hide &
unclutter &

exec ~/scripts/bin/bar.sh &
xlayoutdisplay --dpi 96 &

while type dwm >/dev/null; do
    dwm && continue || read
done
