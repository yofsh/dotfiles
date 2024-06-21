#!/bin/sh
lang=$1

lang_pango=$(echo $lang | tr '[:lower:]' '[:upper:]')

send_notification() {
  echo "$1 - $2"
  notify-send -r "10015" -t 60000 -i google-translate -u low "$1" "$2" 
}

translate_deepl() {
  local target_lang="$1"
  local text="$2"

  if [[ -z "$target_lang" || -z "$text" ]]; then
    echo "Usage: translate_deepl <target_lang> <text>"
    return 1
  fi

  local payload=$(jq -n --arg target_lang "$target_lang" --arg text "$text" '{
    target_lang: $target_lang,
    text: [$text]
  }')

  local auth_key=$DEEPL_KEY

  local response=$(curl -s -X POST \
    -H "Authorization: DeepL-Auth-Key $auth_key" \
    -H "Content-Type: application/json" \
    -d "$payload" \
    "https://api-free.deepl.com/v2/translate")

  if [[ $(echo "$response" | jq -r '.message') == "Quota exceeded" ]]; then
    echo "Error: DeepL API quota exceeded."
    return 1
  elif ! echo "$response" | jq -e '.translations[0].text' >/dev/null 2>&1; then
    echo "Response"
    echo "$response" | jq
    echo "Error: Invalid response or translation failed."
    return 1
  fi

  echo "$response" | jq -r '.translations[0].text'
}


remove_umlauts(){
	echo "$1" | sed 's/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ü/u/g; s/ñ/n/g; s/Á/A/g; s/É/E/g; s/Í/I/g; s/Ó/O/g; s/Ú/U/g; s/Ü/U/g; s/¿//g;'
}

original=$(wl-paste -p)

if [ "$2" = 'replace' ]; then
  send_notification "Getting $lang_pango replacment for:" "$original"
	translation=$(translate_deepl "$1" "$original")
  translation_without_umlauts=$(remove_umlauts "$translation")
	wl-copy "$translation_without_umlauts"
	wtype -M ctrl v
	sleep 0.5
	wl-copy "$original"
  send_notification "Done!"
	exit 0
fi

send_notification "Getting $lang_pango translation for:" "$original"
translation=$(translate_deepl "$1" "$original")
send_notification " " "$translation"
