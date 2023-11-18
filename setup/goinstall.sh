#!/usr/bin/env bash

apps=(
	danielmichaels/gpt/cmd/gpt@latest
	danielmichaels/ds/cmd/ds@latest
	danielmichaels/zet-cmd/cmd/zet@latest
	aandrew-me/tgpt@latest
	charmbracelet/mods@latest
	charmbracelet/glow@latest
	cosmtrek/air@latest
	sqlc-dev/sqlc/cmd/sqlc@latest
	azimjohn/jprq/cli@latest
	rs/curlie@latest
)

for i in "${apps[@]}"; do
	printf "Installing: %s\n" "${i}"
	go install "github.com/${i}"
done
