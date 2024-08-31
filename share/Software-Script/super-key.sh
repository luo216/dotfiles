#!/bin/sh

xdotool keydown super
notify-send "super key down"
sleep 2
xdotool keyup super
notify-send "super key up"
