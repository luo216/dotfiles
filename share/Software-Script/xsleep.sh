#!/bin/bash

# 检查是否提供了参数，如果没有提供，则设置为1
if [ "$#" -eq 0 ]; then
  timeout=0
else
  timeout=$1
fi

# 将字符串转换为整数
timeout=$(($timeout * 60))

# 设置屏幕保护和 DPMS 参数
xset s on
xset +dpms
xset dpms 10 10 10

# 启动 slock 锁屏程序
pkill picom
slock &
sleep 1

# 初始化变量
var=0

# 检测 slock 是否还在运行
while true; do
  sleep 1
  if pgrep -x slock >/dev/null; then
    # 当达到 timeout 次时执行睡眠指令
    if [ $var -eq $timeout ]; then
      /usr/local/bin/wol.sh
      systemctl suspend
      var=0
    else
      ((var++)) # 自增变量
    fi
  else
    # 重新设置 DPMS 参数
    xset dpms 600 600 600
    picom &
    /usr/local/bin/caps2super.sh
    /usr/local/bin/wol.sh
    break
  fi
done

exit 0
