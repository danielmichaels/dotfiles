#!/bin/bash

set -xeou

arkade_tools=(
  crane
  packer
  kubectl
  kubectx
  popeye
  k3sup
  argocd
)

arkade update
if ! command -v arkade &> /dev/null; then
  curl -sLS https://get.arkade.dev | sudo sh
fi
arkade get "${arkade_tools[@]}"
