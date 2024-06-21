#!/bin/sh

usage() {
	echo "
   Usage: $0 [params]

   Region:
    -f, --fullscreen
    -w, --window
    -r, --region

   Action: 
    -s, --save
    -c, --copy 
    -e, --edit

    -n, --notify            Enabled notification
    -l, --location <DIR>    Directory to save screen shots, defaults to $(xdg-user-dir PICTURES)/screenshots

    -u, --upload            Upload file to remote server (TODO: pass args)"
	exit 1
}

notify() {
	if [ "$NOTIFY" = true ]; then
		notify-send -u low -i background "Screenshot $TYPE $ACTION" "$1"
	fi
}

VALID_ARGS=$(getopt -o ufwrascenl:h --long upload,fullscreen,window,region,save,copy,edit,notify,location:,help -- "$@")
if [[ $? -ne 0 ]]; then
	exit 1
fi

# TYPE=${1:-full}
# ACTION=${2:-save}
NOTIFY=false
FN=$(date "+%Y.%m.%d-%H:%M:%S")
EXT="jpeg"
LOCATION=$(xdg-user-dir PICTURES)/screenshots
FILE=$LOCATION/screenshot-$FN.$EXT
TMPFILE=/tmp/src.$EXT

eval set -- "$VALID_ARGS"
while [ : ]; do
	case "$1" in
	-h | --help)
		usage
		;;
	-l | --location)
		LOCATION=$2
		shift
		;;
	-r | --region)
		TYPE=region
		shift
		;;
	-u | --upload)
		UPLOAD=true
		shift
		;;
	-n | --notify)
		NOTIFY=true
		shift
		;;
	-f | --fullscreen)
		TYPE=full
		shift
		;;
	-w | --window)
		TYPE=window
		shift
		;;
	-s | --save)
		ACTION=save
		shift
		;;
	-c | --copy)
		ACTION=copy
		shift
		;;
	-e | --edit)
		ACTION=edit
		shift
		;;
	--)
		shift
		break
		;;
	esac
done

case "$TYPE" in
"region") GEOMETRY=$(slurp 2>&1) ;;
"full") ;;
"window")
	if pgrep -x "Hyprland" >/dev/null; then
		# POS=`hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1`
		# SIZE=`hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g`
		# GEOMETRY="$POS $SIZE"
		GEOMETRY=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == "$(hyprctl activewindow -j | jq -r '.workspace.id')\)"" | jq -r ".at,.size" | jq -s "add" | jq '_nwise(4)' | jq -r '"\(.[0]),\(.[1]) \(.[2])x\(.[3])"' | slurp)
	fi
	if pgrep -x "sway" >/dev/null; then
		GEOMETRY=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)
	fi
	;;
*)
	echo "Please specify action"
	usage
	exit 1
	;;
esac

if [ "$GEOMETRY" = "selection cancelled" ]; then
	echo "Region selection was cancelled, aborting"
	exit 2
fi

if [ -z "$GEOMETRY" ]; then
	grim -t $EXT "/tmp/src.$EXT"
else
	grim -t $EXT -g "$GEOMETRY" "/tmp/src.$EXT"
fi

case "$ACTION" in
"save")
	cp "$TMPFILE" "$FILE"
  convert $TMPFILE $TMPFILE.png
	wl-copy <$TMPFILE.png
	notify "Saved to \n\n$FILE\n\n and copied to clipboard"
	;;
"edit")
	# swappy -f $TMPFILE -o $TMPFILE
	#
	rm $TMPFILE.png
	satty --filename $TMPFILE --output-filename $TMPFILE.png --init-tool brush --copy-command wl-copy --early-exit
	if [ -e "$TMPFILE.png" ]; then
		convert $TMPFILE.png $TMPFILE
		cp "$TMPFILE" "$FILE"
		notify "Image saved!"
	else
		echo "File does not exist"
	fi
	# convert $TMPFILE.png $TMPFILE
	# cp "$TMPFILE" "$FILE"
	# wl-copy <$FILE
	# notify "Copied to clipboard!"
	;;
"copy")
  convert $TMPFILE $TMPFILE.png
	wl-copy <$TMPFILE.png
	notify "Copied to clipboard!"
	;;
*)
  convert $TMPFILE $TMPFILE.png
	wl-copy <$TMPFILE.png
	notify "Copied to clipboard!"
	;;
esac

rm $TMPFILE
rm $TMPFILE.png

#TODO: move to separate script and pipe filename

if [ "$UPLOAD" = true ]; then
	notify "Uploading file to remote server..."
	scp $TMPFILE yof.sh:httpdocs/src/$FN.$EXT
	notify "File uploaded! URL copied"
	echo "https://yof.sh/src/$FN.$EXT"
	wl-copy "https://yof.sh/src/$FN.$EXT"
fi
