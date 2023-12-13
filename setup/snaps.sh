#!/bin/bash

snaps=(
	alacritty
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

for snap in "${snaps[@]}"; do
	sudo snap install "${snap}"
done
