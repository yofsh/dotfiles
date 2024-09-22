#!/usr/bin/env zsh

chatTitle=".*YouTube Music.*"
haTitle=".*Home – Home Assistant.*"
tgTitle=".*Telegram — Mozilla Firefox.*"
bwTitle="Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox"

floating() {
  hyprctl dispatch setfloating "$1"
}

move_workspace() {
  hyprctl dispatch movetoworkspacesilent "special:$2,$1"
}

resize() {
  hyprctl dispatch resizewindowpixel exact "$2" "$3,$1"
}

center() {
  hyprctl dispatch centerwindow "$1"
}

handle_window() {
  local event="${1:0:13}"
  local title="${1:24}"
  local window="address:0x${1:15:8}"

  [[ "$event" != "windowtitlev2" ]] && return
  echo "EVENT: $@"
  echo "Processing window $window with title: $title"

  if [[ "$title" =~ $chatTitle ]]; then
    floating "$window"
    resize "$window" "1740" "95%"
    center "$window"
    move_workspace "$window" "music"

  elif [[ "$title" =~ $haTitle ]]; then
    floating "$window"
    resize "$window" "1740" "95%"
    center "$window"
    move_workspace "$window" "ha"

  elif [[ "$title" =~ $tgTitle ]]; then
    floating "$window"
    resize "$window" "900" "95%"
    center "$window"
    move_workspace "$window" "tg"

  elif [[ "$title" == $bwTitle ]]; then
    floating "$window"
    resize "$window" "400" "600"
    center "$window"
  fi

  echo ""
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
  handle_window "$line"
done
