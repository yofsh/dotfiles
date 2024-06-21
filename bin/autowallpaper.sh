#/bin/sh
#
WPDIR=/home/fobos/pics/wallpapers
username=fobos

monitor=(`hyprctl monitors | grep Monitor | awk '{print $2}'`)
wal=$(find ${WPDIR} -name '*' | awk '!/.git/' | tail -n +2 | shuf -n 1)
cache=""

if [ -d ${WPDIR} ]; then
  cd ${WPDIR}
  git pull
else
  git clone ${wallpaperGit} ${WPDIR}
  chown -R ${username}:users ${WPDIR}
fi

while true; do
  if [[ $cache == $wal ]]; then
    wal=$(find ${WPDIR} -name '*' | awk '!/.git/' | tail -n +2 | shuf -n 1)
  else
    cache=$wal
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $wal
    for m in ''${monitor[@]}; do
      hyprctl hyprpaper wallpaper "$m,$wal"
    done
  fi
  sleep 900
done
