masterInfo=$(amixer -M get Master)

# Check if amixer output is empty
if [ -z "$masterInfo" ]; then
    echo "{\"class\": \"error\", \"text\": \"No output from amixer\"}"
    exit 1
fi

# Check if the Master is unmuted (look for "[on]")
if echo "$masterInfo" | grep -q "\[on\]"; then
    # Extract volume percentage
    volume=$(echo "$masterInfo" | grep -oP '\[\d+%\]' | head -1 | grep -oP '\d+')

    # Ensure volume is numeric
    if ! [[ "$volume" =~ ^[0-9]+$ ]]; then
        echo "{\"class\": \"error\", \"text\": \"Invalid volume\"}"
        exit 1
    fi
    
    # Volume checks
    if [[ $volume -le 100 && $volume -gt 50 ]]; then
        echo "{\"class\": \"unmuted\", \"text\": \" $volume%\"}"
    elif [[ $volume -le 50 && $volume -gt 25 ]]; then
        echo "{\"class\": \"unmuted\", \"text\": \" $volume%\"}"
    elif [[ $volume -le 25 && $volume -gt 0 ]]; then
        echo "{\"class\": \"unmuted\", \"text\": \" $volume%\"}"
    else
        echo "{\"class\": \"unmuted\", \"text\": \" 0%\"}"
    fi
else
    # If Master is muted (look for "[off]")
    echo "{\"class\": \"muted\", \"text\": \"MUTE\"}"
fi

