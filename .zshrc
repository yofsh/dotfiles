if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$HOME/bin/status:$HOME/bin/utils:$PATH"
fi

export PATH="$HOME/dotfiles/bin:$HOME/dotfiles/bin/status:$HOME/dotfiles/bin/utils:$PATH"

nvimman() {
  nvim -c "set ft=man ts=8 nomod nolist nonu noma" -c "Man $*" -c "silent! only"
}
alias man='nvimman'

alias reboot_windows="systemctl reboot --boot-loader-entry=auto-windows"
alias next_boot_windows="sudo bootctl set-oneshot auto-windows"

nix_build_iso() {
  export NIXPKGS_ALLOW_BROKEN=1
  nix run nixpkgs#nixos-generators -- --format iso --flake ~/nix#iso -o ~/nix/$(date +"nix_iso_%Y_%m_%d__%H_%M_%S") 
}

alias ai="aichat"
alias aic="aichat --role %code%"
alias ais="aichat --role %shell%"

alias zz="zellij"
alias za="zellij attach || zellij"
alias zka="zellij kill-all-sessions"
alias zda="zellij delete-all-sessions"

alias hs="nh home switch ~/nix"
alias os="nh os switch ~/nix"
# alias s="nh search"
s() {
  res=$(nh search $1 |
    awk -F"\n" 'BEGIN{RS=""} {
        name=$1
        printf name
        for (i=2; i<=NF; i++) { 
            printf "\n%s", $i
        } 
        printf "\0"
      }' | fzf --read0 --delimiter=$'\0' --tac | cut -d ' ' -f 1 | tr -d "\n")
  if [ -z "$res" ]; then
    echo "No package selected, exiting."
    exit 1
  fi
  echo "Starting shell with package $res"
  # nix shell "nixpkgs#$($pacakge)"
  print -s "nix-shell -p $res --command zsh"
  nix-shell -p "$res" --command "zsh"
}

# alias -g nmap="/usr/bin/nmap $@ $(ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -n1)"

um() {
  if [[ -z "$1" ]]; then
    COUNTRY="$(curl -s ip-api.com/json | jq -r ".country")"
  else
    COUNTRY=$1
  fi
  echo "Updating mirrors for locations : $COUNTRY"
  sudo reflector \
    --download-timeout 10 \
    --connection-timeout 1 \
    --country $COUNTRY \
    --sort rate \
    --verbose \
    --save /etc/pacman.d/mirrorlist \
    --latest 10 --protocol "http,rsync,https"
}

alias p='gping -n 0.1'
alias ppp='sudo gping -n 0.04'

alias stop='pkill -19'
alias cont='pkill -18'

alias g='lazygit'
alias ld='lazydocker'

alias -g v=nvim
alias vim=nvim
alias nn="nnn -T t -i -A -H"
alias f="yazi"
alias optimus_status="cat /sys/bus/pci/devices/0000\:01\:00.0/power/runtime_status"

alias trl="transmission-remote -l"

alias w="watch.sh -t -n0.5"
alias wd="watch -d=permanent --color -n1"

alias rmmeta="exiftool -all= "
alias lsmeta="exiftool -l"

alias l='exa -lah   --group-directories-first'
alias ls='exa'
alias lt='exa -lah   --group-directories-first -s time'
alias wifipw='nmcli dev wifi show-password'
alias -g ssh="TERM=xterm-256color ssh"

# --server 27
alias speed="librespeed-cli  --no-icmp --concurrent 10 --telemetry-level disabled --duration 5 --secure"
alias fast="xdg-open https://fast.com"

alias rsync-copy="rsync -avz --stats --info=progress2 -h"
alias rsync-move="rsync -avz --stats --info=progress2 -h --remove-source-files"
alias rsync-update="rsync -avzu --stats  --info=progress2 -h"
alias rsync-synchronize="rsync -avzu --stats --delete --info=progress2 -h"
#
alias sudoecho=" echo '$1' | sudo tee $2"

o() {
  setsid xdg-open "$1" >/dev/null 2>&1
}

settitle() {
  echo -e "\e]2;$1\007"
}

prepare_for_sale() {
  rm -rf /tmp/forsale
  mkdir /tmp/forsale
  unzip -d /tmp/forsale "$1"
  rm "$1"
  cd /tmp/forsale
  find . -type f -name "*.heic" -exec convert {} "{}.jpg" \;
  rm *.heic*
  exiftool -all= *$2
  magick mogrify -resize 1080 *.$2
}

weather() {
  curl -s v2.wttr.in/$1
}

ipinfo() {
  curl -s "https://ipinfo.io/$1" | jq
}

# ZSH configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt prompt_subst

autoload -Uz compinit promptinit
compinit -C -i
promptinit

autoload colors && colors
autoload -Uz run-help
autoload -U edit-command-line

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  prompt fire
else
  PROMPT='%F{blue}%~ %F{green}❯ %f'
fi

bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

run-tldr() {
  nvim -c 'set ft=markdown nomod nolist nonu noma' <(tldr -m $BUFFER)
}
zle -N run-tldr
bindkey -r '^[t'
bindkey '^[t' run-tldr

run-chtsh() {
  nvim -c 'set ft=markdown nomod nolist nonu noma' <(curl -s cht.sh/$BUFFER | sed -r "s/\x1B\[[0-9;]*[mK]//g")
}
zle -N run-chtsh
bindkey -r '^[g'
bindkey '^[g' run-chtsh

# ZSH Autocomplete settings
setopt COMPLETE_IN_WORD
setopt PATH_DIRS
setopt AUTO_MENU
setopt AUTO_LIST
setopt AUTO_PARAM_SLASH
setopt AUTO_PARAM_KEYS
setopt FLOW_CONTROL

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$XDG_CACHE_HOME/zshcache"

zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'

zstyle ':completion:*' format '  (%d)'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands

zstyle ':completion:*' file-sort modification

zstyle ':completion:*' completer _complete _list _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

source_if_exists() {
  if [[ -f "$1" ]]; then
    source "$1"
  else
    #      echo "WARN: trying to source missing file: $1"
  fi
}

source_if_exists /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source_if_exists /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source_if_exists "$(fzf-share)/key-bindings.zsh"
source_if_exists "$(fzf-share)/completion.zsh"

# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

source_if_exists /etc/grc.zsh

unset -v FZF_DEFAULT_OPTS

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always  --line-range :50 {}'"
export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --color=always --exclude node_modules --exclude .git'
export FZF_DEFAULT_OPTS='--no-height --ansi --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

if [[ -z $DISPLAY && $TTY = /dev/tty1 ]]; then
  export _JAVA_AWT_WM_NONREPARENTING=1/
  export QT_QPA_PLATFORM=wayland
  export XDG_CURRENT_DESKTOP=sway
  export XDG_SESSION_DESKTOP=sway
  export MOZ_ENABLE_WAYLAND=1
  export GDK_BACKEND="wayland,x11"

  get_amd_device() {
    for device in /sys/class/drm/*/device; do
      if [[ -f $device/vendor ]]; then
        ID=$(cat $device/vendor)
        if [[ $ID == *1002* ]]; then
          CARD_PATH=$(echo $device | cut -d'/' -f5)
          echo /dev/dri/$CARD_PATH
          exit 1
        fi
      fi
    done
  }
  # export WLR_DRM_DEVICES=$(get_amd_device)
  # exec Hyprland &>/dev/null
fi

mvp_get() {
  SOCKET='/tmp/mpvsocket'
  printf '{ "command": ["get_property", "%s"] }\n' "$1" | socat - "${SOCKET}" | jq -r ".data"
}

function _copy_buffer() {
  printf "%s" "$BUFFER" | wl-copy
}
zle -N copy_buffer _copy_buffer
bindkey '\ey' copy_buffer

function _showbuffers() {
  local nl=$'\n' kr
  typeset -T kr KR $'\n'
  KR=($killring)
  typeset +g -a buffers
  buffers+="      Pre: ${PREBUFFER:-$nl}"
  buffers+="  Buffer: $BUFFER$nl"
  buffers+="     Cut: $CUTBUFFER$nl"
  buffers+="       L: $LBUFFER$nl"
  buffers+="       R: $RBUFFER$nl"
  buffers+="Killring:$nl$nl$kr"
  zle -M "$buffers"
}
zle -N showbuffers _showbuffers
bindkey "^[o" showbuffers

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

_aichat_zsh() {
  if [[ -n "$BUFFER" ]]; then
    local _old=$BUFFER
    BUFFER+="⌛"
    zle -I && zle redisplay
    BUFFER=$(aichat -e "$_old")
    zle end-of-line
  fi
}
zle -N _aichat_zsh
bindkey '\ee' _aichat_zsh
