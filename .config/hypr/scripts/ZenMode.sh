#!/bin/bash

notif="$HOME/.config/swaync/images/bell.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

HYPR_ZEN_MODE=$(hyprctl getoption animations:enabled -j | jq ".int")
if [ "$HYPR_ZEN_MODE" = "1" ]; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:passes 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    swww kill
    notify-send -e -u low -i "$notif" "Zen enabled. All animations off"
    exit
else
    swww-daemon --format xrgb && swww img "$HOME/.config/rofi/.current_wallpaper" &
    sleep 0.1
    ${SCRIPTSDIR}/PywalSwww.sh
    sleep 0.5
    ${SCRIPTSDIR}/Refresh.sh
    notify-send -e -u normal -i "$notif" "Zen disabled. All animations normal"
    exit
fi
hyprctl reload
