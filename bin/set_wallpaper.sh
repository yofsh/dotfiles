#!/bin/sh
# image="$(pwd)/$1"

image=$1

[ -e "$image" ] && file --mime-type "$image" | grep -qE 'image/(jpeg|jpg|png|gif|bmp|webp|tiff)' || { echo "Not an Image"; exit 1; }

monitor=($(hyprctl monitors | grep Monitor | awk '{print $2}'))
hyprctl hyprpaper unload all
hyprctl hyprpaper preload $image
for m in ''${monitor[@]}; do
  echo "Setting for $m"
  echo "Image: $image"
  hyprctl hyprpaper wallpaper "$m,$image"
done
