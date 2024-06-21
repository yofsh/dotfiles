#!/bin/sh

DEVICE=$1
check_mic() {
	LOOPBACK_LOADED=$(pactl list modules | grep "module-loopback")
	if [ "$LOOPBACK_LOADED" ]; then
		pactl unload-module module-loopback
		echo "Loopback module unloaded"
	else
		pactl load-module module-loopback
		echo "Loopback module loaded"
	fi
}

check_cam() {
	CAMERA=$(find /dev/video* | head -1)
	SIZE=1920x1080
	mpv \
		--title='Volume Control' \
		--profile=low-latency \
		--untimed \
		--demuxer-lavf-o=video_size=$SIZE,input_format=mjpeg \
		--display-tags-clr \
		--msg-level=cplayer=error \
		"av://v4l2:$CAMERA"
}

case $DEVICE in
"mic")
	check_mic
	;;
"cam")
	check_cam
	;;
*)
	check_mic
	check_cam
	check_mic
	;;
esac
