#!/bin/bash

API_URL="https://paperless.yof.sh/api/documents/post_document/"
FILE_PATH=$1
BACKUP_DIR=~/docs_backup

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

echo "Uploading to Paperless: $FILE_PATH"

# Upload the document
if curl -X POST "$API_URL" \
    -H "Authorization: Token $API_TOKEN" \
    -F "document=@$FILE_PATH"; then
    # If upload succeeds, move file to backup directory
    mv "$FILE_PATH" "$BACKUP_DIR"
    echo "Upload succeeded. File moved to $BACKUP_DIR."
else
    # If upload fails, print error message
    echo "Upload failed. File not moved."
fi
