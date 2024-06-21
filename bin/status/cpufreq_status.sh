#!/bin/bash
# cpupower frequency-info | grep '(ass' | awk '{print "  "$4}'

FREQ=$(grep MHz /proc/cpuinfo)

AVR=$(echo "$FREQ" | awk '{sum += $4}; END {printf "%.1f", sum/NR/1000}')
MIN=$(echo "$FREQ" | awk -F":" 'BEGIN { min = 99999999 } { rounded = sprintf("%.1f", $2/1000); if (rounded < min) min = rounded } END { print min }')
MAX=$(echo "$FREQ" | awk -F":" 'BEGIN { max = -99999999 } { rounded = sprintf("%.1f", $2/1000); if (rounded > max) max = rounded } END { print max }')

echo "$MIN $MAX $AVR"
