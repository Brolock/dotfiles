#! /usr/bin/env bash

# NB use iwctl for Wifi on a new machine
# Run this script as sudo
if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

chsh -s /usr/bin/zsh brolock

rm -rf /home/brolock/.config
ln -s $SCRIPT_DIR/config /home/brolock/.config
ln -sf $SCRIPT_DIR/\.* /home/brolock/


pacman -S --noconfirm pamixer alsa-utils \
	ttf-font-awesome \
	python-pip \
	neovim \
	keychain \
	python-psutil \
	ripgrep \
	fzf \
	fasd \
	tree \
	less \

echo "Please logout or restart computer to finalize configuration!"
