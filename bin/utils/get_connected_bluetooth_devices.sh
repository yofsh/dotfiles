#!/bin/bash
bluetoothctl devices | cut -f2 -d' ' | while read -r uuid; do bluetoothctl info "$uuid" | grep -B8 -e 'Connected: yes' | grep 'Name' | cut -f2 -d":"; done
