#!/usr/bin/env sh

show_audio() {
    eww update volume=$(pamixer --get-volume)
    eww open volumemenu --duration 5s
}

status() {
    playerctl metadata --format '{"artist": "{{artist}}", "title": "{{title}}", "artUrl": "{{mpris:artUrl}}", "position": {{position}}, "length": {{mpris:length}}}' $@
}

case "$1" in
    vol-)
        pamixer --decrease 5
        show_audio
        ;;

    vol+)
        pamixer --increase 5
        show_audio
        ;;

    mute)
        pamixer --toggle-mute
        show_audio
        ;;

    play-pause)
        playerctl play-pause
        show_audio
        ;;

    previous)
        playerctl previous
        show_audio
        ;;

    next)
        playerctl next
        show_audio
        ;;

    status)
        status
        ;;

    statusf)
        status --follow
        ;;

    *)
        printf "%s: Unknown command: %s\n" "$0" "$1"
        exit 1
        ;;
esac
