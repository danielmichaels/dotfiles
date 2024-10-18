#!/bin/bash

snaps=(
	chromium-ffmpeg
	discord
	gtk-common-themes
	multipass
	opera
	postman
	slack
	vlc
	zulip
	sqlitebrowser
	insomnia
)

classic=(
	gitkraken
)

for snap in "${snaps[@]}"; do
	sudo snap install "${snap}"
done

for snap in "${classic[@]}"; do
	sudo snap install "${snap}" --classic
done
