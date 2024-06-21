#!/bin/bash
if [ "$1" != "" ]; then
	isActive=$(cat </proc/net/dev | grep "$1")
	if [ "$isActive" ]; then
		echo "{\"text\": \"$2\", \"alt\": \"$2 connected\", \"tooltip\": \"test tooltip\", \"class\": \"active\", \"percentage\": 100 }"
		# echo "[$2]"
	else
		echo "{\"text\": \"$2\", \"alt\": \"$2 connected\", \"tooltip\": \"test tooltip\", \"class\": \"\", \"percentage\": 100 }"
		# echo "$2"
	fi
else
	echo "No network name specified"
fi
