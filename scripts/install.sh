#!/bin/sh

set -eo pipefail

sudo usermod -aG video ${USER}

git clone --bare git@github.com:moetelo/dotfiles.git $HOME/dotfiles/

sudo ln -s ~/.config/00-keyboard.conf /etc/X11/xorg.conf.d/
sudo cp ~/.config/fonts/SetoFontFixed.ttf /usr/share/fonts/TTF

sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay-bin.git
pushd yay-bin > /dev/null
makepkg -si
popd > /dev/null
rm yay-bin -rf

yay_packages=(
    zsh-fast-syntax-highlighting zsh-autosuggestions
    picom iwd dunst solaar unclutter greenclip xray
    xlayoutdisplay numlockx xkb-switch
    nvidia
    curl wget ripgrep jq htop
    visual-studio-code-bin neovim npm
    feh zathura zathura-pdf-mupdf thunar
    firefox mpv chromium telegram-desktop rofi discord
)
yay -S --needed --noconfirm $yay_packages

xdg-mime default org.pwmt.zathura.desktop application/pdf

if [[ ! -f "$HOME/.fehbg" ]]; then
    mkdir -p $HOME/Pictures/
    wget 'https://upload.wikimedia.org/wikipedia/commons/1/1d/Левитан_У_омута.jpg' -O "$HOME/Pictures/Levitan_u_omuta.jpg"
    feh --bg-scale "$HOME/Pictures/Levitan_u_omuta.jpg"
fi

GRUB_FILE='/etc/default/grub'
echo 'GRUB_DISABLE_OS_PROBER=false' >> $GRUB_FILE
sed 's/^GRUB_TIMEOUT=\d+/GRUB_TIMEOUT=1/' < $GRUB_FILE | sudo tee $GRUB_FILE

sudo grub-mkconfig -o /boot/grub/grub.cfg

sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
