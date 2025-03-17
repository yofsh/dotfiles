#!/bin/bash
USER="fobos"
SERVER_URL="yof.sh"
DESTINATION="www"
NOTIFICATION_ENABLED=true
rand=$(LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | fold -w 6 | head -n 1)

# Only define SUCCESS_ICON for Linux systems
if [[ "$OSTYPE" != "darwin"* ]]; then
    SUCCESS_ICON=/usr/share/icons/Papirus/48x48/emblems/checkmark.svg
fi
notify_send() {
    if $NOTIFICATION_ENABLED; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            osascript -e "display notification \"$2\" with title \"$1\"" || true
        else
            notify-send -r 1 -u low -i mintupload "$1" "$2"
        fi
    fi
}

notify_send_success() {
    if $NOTIFICATION_ENABLED; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            osascript -e "display notification \"$2\" with title \"$1\""
        else
            notify-send -r 1 -u low -i $SUCCESS_ICON "$1" "$2"
        fi
    fi
}

copy_url(){
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -n "https://$SERVER_URL/$rand"_"$1" | pbcopy
    else
        wl-copy "https://$SERVER_URL/$rand"_"$1"
    fi
}

if [ $# -eq 1 ]; then
    if [ -d "$1" ]; then
        ARCHIVE_NAME="${1##*/}.zip"
        if ! command -v zip &> /dev/null; then
            echo "Error: zip command not found. Please install it using 'brew install zip'"
            exit 1
        fi
        zip -r "$ARCHIVE_NAME" "$(basename $1)"
        notify_send 'Uploading archived folder...' "$ARCHIVE_NAME"
        scp $ARCHIVE_NAME $USER@$SERVER_URL:$DESTINATION/"$rand"_"$ARCHIVE_NAME"
        rm $ARCHIVE_NAME
        notify_send_success 'Folder archive uploaded!' "$ARCHIVE_NAME"
        copy_url "$ARCHIVE_NAME"
    else
        FILENAME=$(basename $1)
        notify_send 'Uploading file...' "$FILENAME"
        scp "$1" $USER@$SERVER_URL:$DESTINATION/"$rand"_"$FILENAME"
        notify_send_success 'File uploaded!' "$1"
        copy_url "$FILENAME"
    fi
else
    ARCHIVE_NAME="pack.zip"
    FILES_NUM=$#
    zip $ARCHIVE_NAME "$@"
    UPLOAD_SIZE=$(du -sh "$ARCHIVE_NAME" | cut -f1)

    notify_send "Uploading $FILES_NUM archived files..." "Uploaded size: ${UPLOAD_SIZE}. Files packed: ${FILES_NUM}"
    scp $ARCHIVE_NAME $USER@$SERVER_URL:$DESTINATION/"$rand"_"$ARCHIVE_NAME"
    rm $ARCHIVE_NAME
    notify_send_success 'Files uploaded!' "Uploaded size: ${UPLOAD_SIZE}. Files packed: ${FILES_NUM}"
    copy_url $ARCHIVE_NAME
fi
