#!/usr/bin/env bash
set -euox pipefail

if ! command -v mise &>/dev/null; then
	curl https://mise.run | sh
fi

$HOME/.local/share/mise/bin/mise install chezmoi --yes && $HOME/.local/share/mise/bin/mise use chezmoi --yes

chezmoi_args=(
	init
	danielmichaels
	--apply
	--depth 1
	--force
	--keep-going
)

# set CHEZMOI_PURGE=1 to remove source/config files after init and apply
if [[ ${CHEZMOI_PURGE:-0} == 1 ]]; then
	chezmoi_args+=(--purge)
fi

$HOME/.local/share/mise/installs/chezmoi/latest/bin/chezmoi "${chezmoi_args[@]}"

if ! command -v zsh &>/dev/null; then
	sudo apt-get install zsh -y
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	chmod -R 755 ~/.oh-my-zsh/
fi
