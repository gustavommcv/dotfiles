#!/bin/sh

toggle_microphone() {
	pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

microphone_is_muted() {
	pactl get-source-mute @DEFAULT_SOURCE@ | grep -q yes
}

if microphone_is_muted; then
	toggle_microphone && paplay ~/.config/scripts/audios/discord-unmute-sound.mp3
else
	toggle_microphone && paplay ~/.config/scripts/audios/discord-mute-sound.mp3
fi

