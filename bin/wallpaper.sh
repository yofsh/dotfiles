#!/bin/sh
dunstify -u low -i background -r "$ID" "Wallpaper update" "Got parameters: \n $@"
length=10
random_string=$(head -c $length /dev/urandom | base64)

WIDTH=$(swaymsg -t get_outputs | jq ".[0].current_mode.width")
H=$(swaymsg -t get_outputs | jq ".[0].current_mode.height")
HEIGHT=$(("$H" + "$RANDOM" % 10))
ID=3333
TMP=/tmp/wallpaper_$random_string.jpg

download_wp() {
	dunstify -u low -i background -r "$ID" "Wallpaper update" "Getting new wallpaper."
	while read -r SPAM_OUT; do
		dunstify -i background -u low -r "3333" -h "int:value:$SPAM_OUT" "Downloading..."
	done < <(curl -o "$TMP" -L "$1" -# 2>&1 | stdbuf -oL tr '\r' '\n' | grep -o '[0-9]*\.[0-9]' --line-buffered)
	dunstify -u low -i background -r "$ID" "Wallpaper downloaded!"
	# swaymsg output "*" bg $TMP fill
	#
	# xdg-open $TMP
	hyprctl hyprpaper unload all
	hyprctl hyprpaper preload "$TMP"
	hyprctl hyprpaper wallpaper "DP-1,$TMP"
	hyprctl hyprpaper wallpaper "DP-2,$TMP"
	hyprctl hyprpaper wallpaper "DP-3,$TMP"
	hyprctl hyprpaper wallpaper "eDP-1,$TMP"
	hyprctl hyprpaper wallpaper "eDP-2,$TMP"

	hyprctl hyprpaper preload "$TMP"
}

input_string=$1
url_pattern="^(http|https|ftp)://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}(/\S*)?$"

if [[ $input_string =~ $url_pattern ]]; then
	URL="$1/download"
	echo $URL | wl-copy
	download_wp "$URL"
	exit 0
fi

case "$1" in
"image")
	URL="$2"
	download_wp "$URL"
	;;
"qt_unsplash")
	URL="$2/download"
	dunstify "$URL"
	download_wp "$URL"
	;;
*)
	URL="https://source.unsplash.com/${WIDTH}x$HEIGHT?$1"
	download_wp "$URL"
	;;
esac
