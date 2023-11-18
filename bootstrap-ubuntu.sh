#!/bin/bash

packages=(
	git
	vim
	curl
	automake
	gcc
	pkg-config
	libpcre3-dev
	zlib1g-dev
	liblzma-dev
	sqlite3
	rsync
	ubuntu-restricted-extras
	build-essential
	libc-dev
	openssh-server
)

extras=(
	syncthing
	tldr
	entr
	fd-find
)

install_zsh() {
	if ! command -v zsh &>/dev/null; then
		sudo apt-get install zsh -y
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
		chsh -s /usr/bin/zsh
	fi
}

setup() {
	echo "Installing ubuntu base packages"
	sudo apt-get install "${packages[@]}"
	install_zsh
	sudo apt-get install "${extras[@]}"
}
