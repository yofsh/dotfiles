#!/bin/sh
request=$1

send_notification() {
  echo "$1 - $2"
  notify-send -r "10016" -i google-translate -u low "$1" "$2"
}

original=$(wl-paste -p)

if [ "$2" = 'replace' ]; then
  send_notification "$request for" "$original"
	res=$(aichat "$request: $original")
	wl-copy "$res"
	wtype -M ctrl v
	sleep 0.5
	wl-copy "$original"
  send_notification "Done!"
	exit 0
fi

send_notification "$request for:" "$original"
res=$(aichat "$request: $original")
send_notification " " "$translation"
