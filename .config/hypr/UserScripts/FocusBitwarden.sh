#!/bin/bash

CLIENT_NAME="Bitwarden"
CLIENTS=$(hyprctl clients -j)

# Make sure to wrap $CLIENT_NAME in double quotes inside the jq query
OPEN_WINDOWS_FOR_THIS_CLIENT=$(echo "$CLIENTS" | jq "[.[] | select(.class == \"$CLIENT_NAME\")]")

NUM_WINDOWS=$(echo $OPEN_WINDOWS_FOR_THIS_CLIENT | jq length)

if [ "$NUM_WINDOWS" -gt 0 ]; then
    ACTIVE_WINDOW_ADDRESS=$(hyprctl activewindow -j | jq -r '.address')
    if [ "$NUM_WINDOWS" -gt 1 ]; then
        # Focus a different open window for this client
        DIFFERENT_WINDOW=$(echo "$OPEN_WINDOWS_FOR_THIS_CLIENT" | jq -r "[.[] | select(.address != \"$ACTIVE_WINDOW_ADDRESS\")] | sort_by(.focusHistoryID) | last.address")
        if [ -n "$DIFFERENT_WINDOW" ]; then
            hyprctl dispatch focuswindow address:$DIFFERENT_WINDOW &> /dev/null
        fi
    else
        # If there is only one window, focus it
        WINDOW_ADDRESS=$(echo "$OPEN_WINDOWS_FOR_THIS_CLIENT" | jq -r '. | sort_by(.focusHistoryID) | last.address')

        if [ "$WINDOW_ADDRESS" != "$ACTIVE_WINDOW_ADDRESS" ]; then
            hyprctl dispatch focuswindow address:$WINDOW_ADDRESS &> /dev/null
        fi
    fi
else
    # Open a new instance of WhatsApp if it's not open.
    /usr/lib/electron27/electron --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations /usr/lib/bitwarden/app.asar
fi
