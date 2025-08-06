#! /usr/bin/env bash

# Run this script as sudo
#if [ "$EUID" -ne 0 ]
#    then echo "Please run as root"
#    exit
#fi

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

USERNAME=$(whoami)
sudo chsh -s /usr/bin/zsh $USERNAME

rm -rf $HOME/.config
ln -s $SCRIPT_DIR/config $HOME/.config
ln -sf $SCRIPT_DIR/\.* $HOME


## Install Yay
# Yay will prompt a lot for installation
git clone https://aur.archlinux.org/yay.git
(cd yay && makepkg -si --noconfirm && yay -Syu --noconfirm)
#! Yay install

sudo pacman -S --noconfirm pamixer alsa-utils \
	ttf-jetbrains-mono \
	python-pip \
	neovim \
	git \
	keychain \
	python-psutil \
	ripgrep \
	fzf \
	fasd \
	tree \
	less \
	jq \


## Install Arch-Update. Automatic update notifier, handler & helper
# https://github.com/Antiz96/arch-update
# To uninstall run sudo make uninstall the arch-update folder
sudo pacman -S --noconfirm --needed bash systemd pacman pacman-contrib archlinux-contrib curl fakeroot htmlq diffutils hicolor-icon-theme python python-pyqt6 qt6-svg glib2 xdg-utils

# Additional dependencies
sudo pacman -S --noconfirm libnotify qt6-wayland dex

# build dependencies
sudo pacman -S --noconfirm --asdeps make scdoc bats

curl https://github.com/Antiz96/arch-update/releases/latest

tarball_url=$(
	curl -s https://api.github.com/repos/Antiz96/arch-update/releases/latest |
	jq -r ."tarball_url"
)
tarball="arch-update_$(basename $tarball_url)"
wget -O $tarball $tarball_url
mkdir -p arch-update && tar -xvzf $tarball -C arch-update --strip-component 1
rm $tarball
(cd arch-update && make && make test && sudo make install && make clean)

arch-update --tray --enable

#Allows to change default terminal used by arch-update (Alacritty in my case
yay -S --noconfirm xdg-terminal-exec

#! Arch-Update install

# Docker install
pacman -S --noconfirm docker docker-compose
sudo usermod -aG docker brolock
sudo systemctl start docker.service
#! Docker install

echo "Please logout or restart computer to finalize configuration!"
