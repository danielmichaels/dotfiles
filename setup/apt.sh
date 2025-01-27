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
	htop
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
	chromium-browser
	podman
	buildah
	tree
	gparted
  xclip
  libfuse2
  libxi6
  libxrender1
  libxtst6
  mesa-utils
  libfontconfig
  libgtk-3-bin
  tar
  dbus-user-session
  gnome-keyring
  libsecret-tools
)

extras=(
	syncthing
	tldr
	entr
	silversearcher-ag
	nmap
	python-is-python3
	picocom
	minicom
	thonny
	protobuf-compiler
	gnome-boxes
	virt-manager
	qemu-kvm
	libvirt-daemon-system
	libvirt-clients
	bridge-utils
	p7zip-full
	p7zip-rar
	zathura
	peek
	shellcheck
	mpv
	yamllint
  libpcap-dev
  fonts-powerline
  libpq-dev
  xdot
  oathtool
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
