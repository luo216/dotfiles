#!/bin/sh

sleep 0.1

# 脚本选项及其对应的 shell 语句
scripts=(
    "锁定屏幕:dm-tool lock"
    "挂起:systemctl suspend"
    "休眠:systemctl hibernate"
)

# 使用 rofi 显示菜单并获取用户的选择
selected=$(printf "%s\n" "${scripts[@]}" | rofi -dmenu -p "Choose a script to run:")

# 检查用户是否选择了某项
if [ -n "$selected" ]; then
    # 从选择中提取 shell 语句
    command_to_run=$(echo "$selected" | cut -d':' -f2)
    
    # 执行 shell 语句
    eval "$command_to_run"
else
    notify-send "No script selected."
fi
