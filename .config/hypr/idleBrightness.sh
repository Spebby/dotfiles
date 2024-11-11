#!/bin/bash

systemBrightnessFile="/sys/class/backlight/nvidia_0/brightness"
prevBrightnessFile="/tmp/prevBrightness.tmp"

AC_STATUS="/sys/class/power_supply/ADP0/online"

if [ "$AC_STATUS" -eq 1 ]; then
	cat $prevBrightnessFile | doas tee $systemBrightnessFile
	exit 1
fi

if [ "$1" = "startIdle" ]; then
	cat $systemBrightnessFile >$prevBrightnessFile
	cat $prevBrightnessFile
	echo "0" | doas tee $systemBrightnessFile
fi

if [ "$1" = "endIdle" ]; then
	cat $prevBrightnessFile | doas tee $systemBrightnessFile
fi

if [ "$1" = "finalIdle" ]; then
	if ! pgrep -x "emerge" >/dev/null && ! pgrep -x "make" >/dev/null; then
		loginctl suspend
	fi
fi
