#!/bin/bash
# Usage: get_title.sh [URL] [TYPE]
TYPE=$2
URL=$1
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36"
TITLE=$(curl -L -H "user-agent: $UA" "$URL" -so - | tr -d '\n' | \grep -iPo '(?<=<title>)(.*)(?=</title>)' | tr -d '\n')

case "$TYPE" in
markdown)
	echo "[$TITLE]($URL)"
	;;
*)
	echo "$TITLE"
	;;
esac
