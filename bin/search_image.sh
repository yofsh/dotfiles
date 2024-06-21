#!/bin/sh
EXT="jpeg"
IMAGE="/tmp/gsimg.$EXT"
GEOMETRY="$(slurp)"

if [ -z "$GEOMETRY" ]; then
	exit 1
fi

echo "$GEOMETRY" "$IMAGE"

grim -t $EXT -g "$GEOMETRY" -q 60 "$IMAGE"

if [ ! -f "$IMAGE" ]; then
	echo "No image to search, exiting."
	exit 1
fi

notify-send -i $IMAGE -u low "Sending image to google"
GOOGLEURL=$(curl -i -s -F sch=sch -F "encoded_image=@$IMAGE" https://lens.google.com/upload | grep -oP '(?<=url=).*?(?=")')
URL="https://lens.google.com$GOOGLEURL"
echo URL:
echo $URL
rm $IMAGE
firefox "$URL"
