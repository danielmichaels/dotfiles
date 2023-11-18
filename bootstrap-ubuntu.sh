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
	silversearcher-ag
)

arkade_tools=(
	faas-cli
	crane
	croc
	dagger
	flux
	flyctl
	lazygit
	packer
	gh
	k9s
	kubectl
	kubectx
	popeye
	yq
	jq
	golangci-lint
	atuin
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

k8s-tooling() {
	if ! command -v arkade &>/dev/null; then
		curl -sLS https://get.arkade.dev | sudo sh
	fi
	arkade get "${arkade_tools[@]}"
}

rtx-install() {
	rtx install --yes
}

run() {
	_pre
	sudo apt-get install -y "${packages[@]}"
	install_zsh
	sudo apt-get install -y "${extras[@]}"
	k8s-tooling
	rtx-install
}

run
