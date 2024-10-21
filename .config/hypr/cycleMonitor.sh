#!/bin/bash

# get all monitors
monitors=($(hyprctl monitors -j | jq -r '.[] | .name'))

# get the currently "focused" monitor.
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# get index of active monitor
focused_index=-1
for i in "${!monitors[@]}"; do
	if [[ "${monitors[$i]}" == "$focused_monitor" ]]; then
		focused_index=$i
		break
	fi
done

# Move to next or prev monitor based on argument

# This works alright assuming the mouse gets moved between executions, which should be the case 99% of the time.
# My hunch is that b/c hypr
if [ "$1" == "next" ]; then
	target=$(((focused_index + 1) % ${#monitors[@]}))
	echo $target

	# if we want to move the current window to that monitor, then...
	if [ "$2" = "move" ]; then
		hyprctl dispatch split-changemonitor next
	else
		# otherwise, we're just changing focus
		hyprctl dispatch focusmonitor "${monitors[$target]}"
		echo "Changed monitor to: ${monitors[$target]}"
	fi
elif [ "$1" = "prev" ]; then
	target=$(((focused_index - 1) % ${#monitors[@]}))
	echo $target

	if [ "$2" = "move" ]; then
		hyprctl dispatch split-changemonitor prev
	else
		hyprctl dispatch focusmonitor "${monitors[$target]}"
		echo "Changed monitor to: ${monitors[$target]}"
	fi
fi
