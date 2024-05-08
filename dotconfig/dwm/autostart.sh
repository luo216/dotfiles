#!/bin/sh

xrandr --output HDMI-1 --auto --below eDP-1
xrandr --output HDMI-1 --brightness 0.8
xrandr --output HDMI-1-1 --brightness 0.8
xrandr --output HDMI-1 --scale 0.8x0.8
xinput map-to-output 13 "HDMI-1"

# background
picom &
feh --bg-fill /usr/share/background/background.b9890328.png

# mount disk
udiskie -ans &

# applet
blueman-applet &
nm-applet &
pasystray &

# pinyin
fcitx5 &

# polkit password agent
# rofi-polkit-agent &
/usr/lib/xfce-polkit/xfce-polkit &
setxkbmap -option "caps:super"

sleep 2

# exit or paru -Syu
st -e sh -c "neofetch && echo -e 'If you need to update the system\nplease enter the password\nthis will execute the {Paru -Syu} instruction' && paru -Syu && zsh"
# nvidia
optimus-manager-qt &
setxkbmap -option "caps:super"
