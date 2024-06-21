#!/bin/sh
PID=$(pgrep wf-recorder)

TYPE=${1:-region}
if [ -z "$PID" ]; then
	FILENAME=$(xdg-user-dir VIDEOS)/$(date +'recording-%Y.%m.%d-%H:%M:%S.mp4')

	case "$TYPE" in
	"region") GEOMETRY=$(slurp) ;;
	"full") GEOMETRY=$(slurp -o) ;;
  # TODO: update to work with Hyprland
	"window") GEOMETRY=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp) ;;
	*) GEOMETRY=$(slurp) ;;
	esac

	if [ -z "$GEOMETRY" ]; then
		pkill -RTMIN+8 waybar
		exit 1
	fi

  echo "Starting recording"
	echo "$FILENAME $GEOMETRY"
	wf-recorder -f "$FILENAME" -g "$GEOMETRY" -a > /dev/null 2>&1 &
  echo "Recording started"
else
	pkill --signal SIGINT wf-recorder
	notify-send -u low -i camera "Recording complete"
	echo "Recording complete"
fi
sleep 0.2
pkill -RTMIN+8 waybar
