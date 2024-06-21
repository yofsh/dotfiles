#!/bin/bash
# Displays notification with current playerctl media.
# --follow can be passed and it will show notification each time media is changed.

IFS="#"
FORMAT="{{markup_escape(artist)}}#{{markup_escape(title)}}#{{markup_escape(album)}}#{{mpris:artUrl}}"
TIMEOUT=3000
ID=9991

while read -r artist title album url; do
	notify-send -t $TIMEOUT -u low -i "$url" -r $ID "$title" "<span font_weight='bold' color='#777777'>$artist</span>\n<i>$album</i>"
done < <(playerctl metadata --format $"$FORMAT" "$@")
