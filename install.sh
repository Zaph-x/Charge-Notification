#!/usr/bin/sh

# Check if the user is root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

if ! [ -x "$(command -v paplay)" ]; then
    echo "Error: paplay is not installed." >&2
    exit 1
fi


# check if folder exists
if [ ! -d "/usr/share/sounds/freedesktop/stereo/" ]; then
    echo "Creating folder /usr/share/sounds/freedesktop/stereo/"
    mkdir -p /usr/share/sounds/freedesktop/stereo/
fi

if [ -f /usr/share/sounds/freedesktop/stereo/window-attention.oga ]; then
    echo "Sound file exists"
else
    echo "Sound file does not exist"
    echo "Copying sound file"
    cp window-attention.oga /usr/share/sounds/freedesktop/stereo/
fi


# Install the package
install battery-notification.sh /usr/bin/battery-notification.sh

cp battery-notification.service /etc/systemd/system/ && sudo systemctl enable battery-notification.service && sudo systemctl start battery-notification.service
cp battery-notification.timer /etc/systemd/system/ && sudo systemctl enable battery-notification.timer && sudo systemctl start battery-notification.timer

echo "Service: $(systemctl is-active battery-notification.service)"
echo "Timer: $(systemctl is-active battery-notification.timer)"
