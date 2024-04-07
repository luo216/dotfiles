#!/bin/sh

# background
picom &
feh --bg-fill /home/steve/.local/share/background/back.jpg

# mount disk
udiskie -ans &

# applet
blueman-applet &
nm-applet &
pasystray &

# pinyin
fcitx5 &

# polkit password agent
rofi-polkit-agent &

xrandr --output HDMI-1 --brightness 0.4
setxkbmap -option "caps:super"
