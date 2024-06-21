#!/bin/bash
# gets youtube url with timecode from existing MPV

mpvget() {
	SOCKET='/tmp/mpvsocket'
	printf '{ "command": ["get_property", "%s"] }\n' "$1" | socat - "${SOCKET}" | jq -r ".data"
}

URL="$(mpvget "path" | cut -f1 -d"&")"
# TIME="$(mpvget "time-pos" | cut -f1 -d".")"
echo $URL

# echo "$URL&t=$TIME"
