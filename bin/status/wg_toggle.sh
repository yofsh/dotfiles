#!/bin/bash
isActive=$(cat </proc/net/dev | grep "$1")
if [ "$isActive" ]; then
	wg-quick down "$1" >/tmp/wg.log 2>&1
else
	for i in $(sudo wg show | grep "interface:" | awk '{print $2}'); do wg-quick down "$i"; done
	wg-quick up "$1" >/tmp/wg.log 2>&1
fi

pkill -RTMIN+9 waybar
