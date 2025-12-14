#!/bin/sh

toggle_microphone() {
	swayosd-client --input-volume mute-toggle
}

microphone_is_muted() {
	pactl get-source-mute @DEFAULT_SOURCE@ | grep yes
}

if microphone_is_muted; then
	toggle_microphone && paplay ~/.config/hypr/audios/discord-unmute-sound.mp3
else
	toggle_microphone && paplay ~/.config/hypr/audios/discord-mute-sound.mp3
fi


