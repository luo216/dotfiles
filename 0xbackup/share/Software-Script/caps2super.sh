#!/bin/bash

# 获取大写锁定状态
caps_status=$(xset q | grep "Caps Lock" | awk '{print$4}')

# 检查大写锁定是否开启
if [ "$caps_status" = "on" ]; then
  echo "大写锁定已开启"
else
  echo "大写锁定已关闭,执行键盘映射"
  setxkbmap -option "caps:super"
fi
