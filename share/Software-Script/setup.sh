#!/bin/sh

# 将当前目录下的所有 .sh 文件软连接到指定目录
link_dir="/usr/local/bin/"
pwd="$(pwd)"

# 使用 expect 来处理 sudo 密码输入
for file in *.sh; do
  if [ -f "$file" ]; then
    path="${pwd}/${file}"
    ln -s $path $link_dir
    # 检查 expect 命令是否成功执行
    if [ $? -eq 0 ]; then
      echo "Linked $path to$link_dir"
    else
      echo "Failed to link $path to$link_dir"
      exit 1
    fi
  fi
done
