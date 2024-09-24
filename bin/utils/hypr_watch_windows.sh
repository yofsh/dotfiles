#!/usr/bin/env zsh

music="YouTube Music — Mozilla Firefox"
ha="Home Overview – Home Assistant — Mozilla Firefox"
tg="Telegram — Mozilla Firefox"
bw="Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox"
gpt="Open WebUI — Mozilla Firefox"

floating() {
  hyprctl dispatch setfloating "$1"
  # sleep 0.2
}

move_workspace() {
  hyprctl dispatch movetoworkspacesilent "special:$2,$1"
}

resize() {
  hyprctl dispatch resizewindowpixel exact "$2" "$3,$1"
  # sleep 0.4
}

center() {
  hyprctl dispatch centerwindow "$1"
}

handle_window() {
  IFS='>' read -r event rest <<< "$1"
  IFS=',' read -r address title <<< "$rest"
  local window="address:0x${address:1}"

  [[ "$event" != "windowtitlev2" ]] && return
  echo "EVENT: $@"
  echo "W: $window"
  echo "T: $title"

  case "$title" in
    ($music)
      floating "$window"
      resize "$window" "1740" "95%"
      center "$window"
      move_workspace "$window" "music"
      center "$window"
      ;;
    
    ($ha)
      floating "$window"
      resize "$window" "1740" "95%"
      center "$window"
      move_workspace "$window" "ha"
      center "$window"
      ;;
    
    ($tg)
      floating "$window"
      resize "$window" "900" "95%"
      center "$window"
      move_workspace "$window" "tg"
      center "$window"
      ;;
    
    ($bw)
      floating "$window"
      resize "$window" "400" "600"
      center "$window"
      ;;

    ($gpt)
      floating "$window"
      resize "$window" "1740" "95%"
      center "$window"
      move_workspace "$window" "gpt"
      center "$window"
      ;;
    
    (*)
      ;;
  esac

  echo ""
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
  handle_window "$line"
done
