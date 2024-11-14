#!/usr/bin/env sh

workspaces() {
    hyprctl workspaces -j | tr '\n' ' '; printf '\n'
}

workspacesf() {
    workspaces

    socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
        workspaces
    done
}

monitors() {
    hyprctl monitors -j | tr '\n' ' '; printf '\n'
}

monitorsf() {
    monitors

    socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
        monitors
    done
}

case "$1" in
    workspaces)
        workspaces
        ;;

    workspacesf)
        workspacesf
        ;;

    monitors)
        monitors
        ;;

    monitorsf)
        monitorsf
        ;;

    *)
        printf "%s: Unknown command: %s\n" "$0" "$1"
        exit 1
        ;;
esac

