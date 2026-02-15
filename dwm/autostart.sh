#!/bin/bash

TOUCHMAPID=10
MOUSE='pointer:CX UGREEN Slim Mouse'

MODE=$(optimus-manager --print-mode | awk '{print$NF}')
HDMI=HDMI-1
DP=eDP-1

if [ "$MODE" == "nvidia" ]; then
  HDMI=HDMI-1-1
  DP=eDP-1-1
fi

xrandr --output $DP --mode 1920x1080 --pos 0x0
xrandr --output $DP --scale 1.2x1.2
# xrandr --output $DP --off
xrandr --output $HDMI --mode 1920x1080 --pos 0x0
xrandr --output $HDMI --brightness 0.6
xrandr --output $HDMI --scale 1.2x1.2
# xrandr --output $DP --scale 1.2x1.2
xrandr --output $HDMI --primary
xinput map-to-output $TOUCHMAPID "$HDMI"
xinput --set-prop "$MOUSE" 'libinput Accel Speed' -0.9
# xinput --set-prop "$MOUSE" 'Coordinate Transformation Matrix' 0.6 0 0 0 0.6 0 0 0 2

nm-applet &
blueman-applet &
pasystray &

/usr/lib/xfce-polkit/xfce-polkit &

# keymap
caps2super.sh &

# background
feh --bg-fill ~/.local/share/wallpaper/default.png
