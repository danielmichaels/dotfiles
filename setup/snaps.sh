#!/bin/bash

snaps=(
	amz-workspaces
	chromium-ffmpeg
	code
	discord
	firefox
	gtk-common-themes
	multipass
	opera
	postman
	restfox
	slack
	vlc
	zulip
	sqlitebrowser
	insomnia
)

classic=(
	alacritty
)

for snap in "${snaps[@]}"; do
	sudo snap install "${snap}"
done

for snap in "${classic[@]}"; do
	sudo snap install "${snap}" --classic
done
