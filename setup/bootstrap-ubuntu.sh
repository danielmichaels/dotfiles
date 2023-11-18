#!/bin/bash

scripts=(
	apt.sh
	arkade.sh
	goinstall.sh
	ngrok.sh
	docker.sh
	docker-compose.sh
)

execute-scripts() {
	for script in "${scripts[@]}"; do
		"./${HOME}/.local/share/chezmoi/setup/${script}"
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
