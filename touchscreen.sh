#!/bin/bash
devices=""
xinput list | grep -i "touch" | grep -Po "\s+id=\d+"
if [ $? -eq 0 ]; then
    devices=$(xinput list | grep -i "touch" | grep -Po "\s+id=\d+" | cut -d "=" -f 2)
fi
udev_devices=""
udev_device=$(udevadm info --export-db | awk '/ID_INPUT_TOUCHSCREEN=1/' RS= | grep '^E: NAME=' | cut -d '"' -f 2)
if [ "$udev_device" != "" ]; then
    xinput list | grep -Po "$udev_device\s+id=\d+"
    if [ $? -eq 0 ]; then
        udev_devices=$(xinput list | grep -Po "$udev_device\s+id=\d+" | cut -d "=" -f 2)
    fi
fi
devices=$(echo "$devices $udev_devices" | xargs)
xrandr | grep -Po "\s+connected\s+\d+"
if [ $? -eq 0 ]; then
    vga=$(xrandr | grep -Po "(VGA|DP)-\d+\s+connected" -m 1 | cut -d ' ' -f 1)
    hdmi=$(xrandr | grep -Po "HDMI-\d+\s+connected" | cut -d ' ' -f 1)
    xrandr --output $vga --left-of $hdmi
    for device in $devices; do
        xinput --map-to-output $device $hdmi
    done
else
    for device in $devices; do
        xinput --map-to-output $device $(xrandr | grep -Po "[-A-Z0-9]+\s+connected\s+primary" | cut -d ' ' -f 1)
    done
fi
