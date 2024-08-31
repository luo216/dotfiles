#!/bin/sh

# 脚本列表
scripts=(
    "键盘重映射:/usr/local/bin/caps2super.sh"
    "系统监视器:/usr/bin/mate-system-monitor"
    "todesk屏幕:/home/steve/.screenlayout/layout.sh"
    "default屏幕:/home/steve/.screenlayout/default.sh"
    "锁屏:/usr/local/bin/slock"
    "休眠:/usr/local/bin/xsleep.sh"
    "屏幕亮度:/usr/local/bin/xscreenlight.sh"
    "按住super键2秒:/usr/local/bin/super-key.sh"
    "使用root用户启动应用:/usr/local/bin/root-start.sh"
)

# 使用 rofi 显示菜单并获取用户的选择
selected=$(printf "%s\n" "${scripts[@]}" | rofi -dmenu -p "Choose a script to run:")

# 检查用户是否选择了某项
if [ -n "$selected" ]; then
    # 从选择中提取脚本路径
    script_to_run=$(echo "$selected" | cut -d':' -f2)
    
    # 检查脚本是否存在
    if [ -f "$script_to_run" ]; then
        # 执行脚本
        $script_to_run
    else
        notify-send "The selected script does not exist."
    fi
else
    notify-send "No script selected."
fi
