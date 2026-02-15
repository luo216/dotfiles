#!/bin/sh

TOUCHMAPID=10
MOUSE='pointer:CX UGREEN Slim Mouse'

MODE=$(optimus-manager --print-mode | awk '{print$NF}')
HDMI=HDMI-1
DP=eDP-1

if [ "$MODE" != "integrated" ]; then
  HDMI=HDMI-1-1
  DP=eDP-1-1
fi

wol.sh &
# xrandr --output $DP --mode 1920x1080 --pos 0x0
xrandr --output $DP --off
xrandr --output $HDMI --mode 2160x1440 --pos 0x-1440
# xrandr --output $HDMI --brightness 0.6
# xrandr --output $HDMI --scale 1.2x1.2
# xrandr --output $DP --scale 1.2x1.2
xrandr --output $HDMI --primary
xinput map-to-output $TOUCHMAPID "$HDMI"
xinput --set-prop "$MOUSE" 'libinput Accel Speed' -0.9
# xinput --set-prop "$MOUSE" 'Coordinate Transformation Matrix' 0.6 0 0 0 0.6 0 0 0 2
# ~/.screenlayout/layout.sh

# background
picom &
feh --bg-fill /usr/share/background/back.png
myconky &

# mount disk
udiskie -ans &
# nvidia
optimus-manager-qt &
# applet
blueman-applet &
nm-applet &
pasystray &

# pinyin
fcitx5 &

# polkit password agent
/usr/lib/xfce-polkit/xfce-polkit &
# keymap
caps2super.sh &
# xautolock -time 10 -locker 'Xsleep 20' &

sleep 2
# sunshine
kdeconnect-indicator &
# /usr/bin/rQuickShare &
sunshine &

wezterm

# keymap
caps2super.sh &
