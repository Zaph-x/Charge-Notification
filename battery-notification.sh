#!/usr/bin/sh
# battery-notification.sh
# Author: @zaph-x
# Description: A simple script to notify the user when the battery is low
# Dependencies: notify-send
# Usage: ./battery-notification.sh


# calculate percentage

export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/${UID}/bus}"
export XDG_RUNTIME_DIR=/run/user/1000


PERCENTAGE=$(echo "scale=4; $(cat /sys/class/power_supply/BAT*/energy_now | awk '{ s+=$1 } END { print s }')/$(cat /sys/class/power_supply/BAT*/energy_full | awk '{ s+=$1 } END { print s }') * 100" | bc)

# substring the last two digits
PERCENTAGE=${PERCENTAGE%00}

# Check the battery status of both batteries if they are charging or discharging
STATUS=$(cat /sys/class/power_supply/BAT*/status)

# notify if battery is low
if [ $(echo "$PERCENTAGE < 20" | bc) -eq 1 ] && [[ $STATUS =~ "Discharging" ]]; then
    notify-send -i "/usr/share/icons/Adwaita/scalable/status/battery-level-10-symbolic.svg" "Battery low" "Battery is at $PERCENTAGE%"
    paplay /usr/share/sounds/freedesktop/stereo/window-attention.oga
fi
