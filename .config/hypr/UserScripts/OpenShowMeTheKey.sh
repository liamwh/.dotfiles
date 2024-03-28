#!/bin/bash

CLIENT_NAME="google-chrome"
CLIENTS=$(hyprctl clients -j)

# Convert .class to lowercase and compare with lowercase CLIENT_NAME inside the jq query
OPEN_WINDOWS_FOR_THIS_CLIENT=$(echo "$CLIENTS" | jq "[.[] | select(.class | ascii_downcase == \"$CLIENT_NAME\")]")

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
    # Open a new instance of Chrome if it's not open.
    /opt/google/chrome/chrome &> /dev/null &
fi
