#!/bin/bash

packages=(
	git
	vim
	curl
	automake
	autoconf
	make
	cmake
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
	silversearcher-ag
	nmap
	python-is-python3
	shfmt
	picocom
	minicom
)

_pre() {
	sudo apt update
}

install_zsh() {
	if ! command -v zsh &>/dev/null; then
		sudo apt-get install zsh -y
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
		chsh -s /usr/bin/zsh
	fi
}

run() {
	_pre
	sudo apt-get install -y "${packages[@]}"
	install_zsh
	sudo apt-get install -y "${extras[@]}"
}

run
