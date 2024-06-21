#!/bin/sh

TIMEOUT=$1
DELAY=$2

if [ -z "$TIMEOUT" ]; then
	TIMEOUT=10
fi

if [ -z "$DELAY" ]; then
	DELAY=2
fi

COUNTER=0
while ! ping -c 1 -W 1 1.1.1.1 >/dev/null; do
	echo "Waiting for the internet..."
	sleep $DELAY
	COUNTER=$((COUNTER + DELAY))
	if [ "$COUNTER" -gt $TIMEOUT ]; then
		echo "Still no internet connecting, exiting."
		exit 1
	fi
done

echo "Internet is up!"
