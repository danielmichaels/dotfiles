#!/bin/bash

set -xeou

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
	task
)

if ! command -v arkade &>/dev/null; then
	curl -sLS https://get.arkade.dev | sudo sh
fi
arkade get "${arkade_tools[@]}"
