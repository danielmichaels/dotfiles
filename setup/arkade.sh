#!/bin/bash

set -xeou

arkade_tools=(
	faas-cli
	crane
	croc
	dagger
	flux
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
	goreleaser
	flyctl
)

arkade update
if ! command -v arkade &>/dev/null; then
	curl -sLS https://get.arkade.dev | sudo sh
fi
arkade get "${arkade_tools[@]}"
