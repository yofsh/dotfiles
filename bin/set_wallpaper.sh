#!/bin/sh
# image="$(pwd)/$1"

image=$1

[ -e "$image" ] && file --mime-type "$image" | grep -qE 'image/(jpeg|jpg|png|gif|bmp|webp|tiff)' || { echo "Not an Image"; exit 1; }

# Get absolute path
if [ ! "${image:0:1}" = "/" ]; then
    image="$(pwd)/$image"
fi

# Detect operating system
if [ "$(uname)" = "Darwin" ]; then
    # macOS
    echo "Setting wallpaper for macOS"
    echo "Image: $image"
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$image\""
else
    # Linux (Hyprland)
    monitor=($(hyprctl monitors | grep Monitor | awk '{print $2}'))
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $image
    for m in ''${monitor[@]}; do
      echo "Setting for $m"
      echo "Image: $image"
      hyprctl hyprpaper wallpaper "$m,$image"
    done
fi
