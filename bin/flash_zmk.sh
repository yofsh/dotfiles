#!/bin/bash

DEV=/dev/$2
PART=$1 #left or right

sudo mount "$DEV" /mnt
sudo cp ./*$PART* /mnt/

sync
sleep 1

echo "Firmware copied to $DEV!"
