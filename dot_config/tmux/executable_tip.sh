#!/bin/sh
# Print one tip from tips.txt for the tmux status bar, changing every 10 minutes.
f="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tips.txt"
[ -r "$f" ] || exit 0
n=$(grep -c . "$f")
[ "$n" -gt 0 ] || exit 0
grep . "$f" | sed -n "$(( $(date +%s) / 600 % n + 1 ))p"
