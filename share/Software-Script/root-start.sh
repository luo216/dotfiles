#!/bin/bash

sleep 0.1

# 使用 rofi 获取密码
password=$(rofi -dmenu -password -i -p "Enter your password for sudo: ")

# 如果用户没有输入密码或取消了操作，则退出脚本
if [ -z "$password" ]; then
  exit 1
fi

echo "$password" | sudo -S /usr/local/bin/rofi -show
