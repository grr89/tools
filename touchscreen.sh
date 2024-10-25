#!/bin/bash
devices=$(xinput list | grep -i "touch" | grep -i -v "mouse" | grep -Po "\s+id=\d+" | cut -d "=" -f 2)
if [ $? -ne 0 ]; then
    devices=""
fi
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