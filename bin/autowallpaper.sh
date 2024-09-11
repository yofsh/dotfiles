#/bin/sh
WPDIR=/home/fobos/pics/wallpapers
monitor=($(hyprctl monitors | grep Monitor | awk '{print $2}'))

echo "Motitors are: $monitor"

hyprctl hyprpaper unload all
prev=""
while true; do
  wal=$(find ${WPDIR} -name '*' | awk '!/.git/' | tail -n +2 | shuf -n 1)

  echo "Preloading new"
  hyprctl hyprpaper preload $wal
  for m in ''${monitor[@]}; do
    echo "Setting $wal, for $m"
    hyprctl hyprpaper wallpaper "$m,$wal"
  done
  echo "Unload prev"
  hyprctl hyprpaper unload "$prev"
  prev=$wal
  sleep 900
done
