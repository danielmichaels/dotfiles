#!/bin/bash

scripts=(
	apt.sh
	arkade.sh
	goinstall.sh
	ngrok.sh
	docker.sh
	docker-compose.sh
	snaps.sh
	nvim.sh
)

execute-scripts() {
	for script in "${scripts[@]}"; do
		bash "${HOME}/.local/share/chezmoi/setup/${script}"
	done
}

rtx-install() {
	rtx install --yes
}

run() {
	rtx-install
	execute-scripts
}

run
