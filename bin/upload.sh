#!/bin/sh
USER="fobos"
SERVER_URL="yof.sh"
DESTINATION="www"
NOTIFICATION_ENABLED=true
rand=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
SUCCESS_ICON=/usr/share/icons/Papirus/48x48/emblems/checkmark.svg

echo $0;
echo $1;
echo "$@";
exit 1;
#FIXME: brokken when Yazi pass path with spacebar :/

notify_send() {
    if $NOTIFICATION_ENABLED; then notify-send -r 1 -u low -i mintupload "$1" "$2"; fi
}

notify_send_success() {
    if $NOTIFICATION_ENABLED; then notify-send -r 1 -u low -i $SUCCESS_ICON "$1" "$2"; fi
}

copy_url(){
  wl-copy https://$SERVER_URL/"$rand"_"$1"
  # notify-send -r 2 -u low -i mintupload "Link copied"
}

if [ $# -eq 1 ]; then
    if [ -d "$1" ]; then
        ARCHIVE_NAME="${1##*/}.zip"
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
