#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
polybar main &

if [[ $(xrandr -q | grep 'DP2 connected') ]]; then
	polybar external &
fi


# #!/usr/bin/env bash

# # Terminate already running bar instances
# killall -q polybar

# # Wait until the processes have been shut down
# while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# # Launch bar
# polybar main &
# #polybar bot

# echo "Bars launched..."