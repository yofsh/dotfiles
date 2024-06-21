#!/bin/bash
BAT=/sys/class/power_supply/BATT
AC=$(cat /sys/class/power_supply/ACAD/online)
if [ "$AC" == 0 ]; then
	echo - | awk "{printf \"%.1f\", $(($(cat "$BAT/current_now") * $(cat "$BAT/voltage_now"))) / 1000000000000 }"
	# echo - | awk "{printf \"%.1f\", $(($(cat "$BAT/power_now"))) / 1000000 }"
	echo "↑"
else
	echo - | awk "{printf \"%.1f\", $(($(cat "$BAT/current_now") * $(cat "$BAT/voltage_now"))) / 1000000000000 }"
	# echo - | awk "{printf \"%.1f\", $(($(cat "$BAT/power_now"))) / 1000000 }"
	echo "↓"
fi

