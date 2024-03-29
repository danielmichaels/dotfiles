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
	yq
	jq
	golangci-lint
	atuin
	task
	popeye
	k3sup
	argocd
)

if ! command -v arkade &>/dev/null; then
	curl -sLS https://get.arkade.dev | sudo sh
fi
arkade get "${arkade_tools[@]}"
