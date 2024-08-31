#!/bin/sh

ZEROTIER="ip route add 10.3.161.0/24 via 192.168.1.1 dev enp2s0"
ROUTE="default via 192.168.31.64 dev wlp0s20f3 proto static metric 50"

# 使用 rofi 获取密码
password=$(rofi -dmenu -password -i -p "Enter your password for sudo: ")
option=$(echo -e "ON\nOFF" | rofi -dmenu -p "Select Option:")

# 如果用户没有输入密码或取消了操作，则退出脚本
if [ -z "$password" ] || [ -z "$option" ]; then
  exit 1
fi

# 使用引号来确保比较的是字符串
if [ "$option" = "ON" ]; then
  echo "$password" | sudo -S ip route add $ROUTE
fi

if [ "$option" = "OFF" ]; then
  echo "$password" | sudo -S ip route del $ROUTE
fi

echo "$password" | sudo -S $ZEROTIER

default=$(ip route show default | head -n 1 | awk '{print $5}')
notify-send "Route changed to $default"
