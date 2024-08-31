#!/bin/sh

MODE=$(optimus-manager --print-mode | awk '{print$NF}')
HDMI=HDMI-1
DP=eDP-1

if [ "$MODE" != "integrated" ]; then
  HDMI=HDMI-1-1
  DP=eDP-1-1
fi

xrandr --output $HDMI --brightness 0.6
