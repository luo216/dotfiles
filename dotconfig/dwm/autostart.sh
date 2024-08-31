#!/bin/sh

TOUCHMAPID=13

MODE=$(optimus-manager --print-mode | awk '{print$NF}')
HDMI=HDMI-1
DP=eDP-1

if [ "$MODE" != "integrated" ]; then
  HDMI=HDMI-1-1
  DP=eDP-1-1
fi

/usr/local/bin/wol.sh &
xrandr --output $DP --mode 1920x1080 --pos 0x0
xrandr --output $HDMI --mode 1920x1080 --pos 2304x0
xrandr --output $HDMI --brightness 0.8
xrandr --output $HDMI --scale 1.2x1.2
xrandr --output $DP --scale 1.2x1.2
xrandr --output $HDMI --primary
xinput map-to-output $TOUCHMAPID "$HDMI"

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
/usr/local/bin/caps2super.sh &
# xautolock -time 10 -locker 'Xsleep 20' &

sleep 2
# sunshine
kdeconnect-indicator &
/usr/bin/rQuickShare &
sunshine &

# exit or paru -Syu
st -e sh -c "fastfetch && echo -e 'If you need to update the system\nplease enter the password\nthis will execute the {Paru -Syu} instruction' && paru -Syu && setxkbmap -option 'caps:super' && zsh"
# keymap
/usr/local/bin/caps2super.sh &
