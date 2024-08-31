#!/bin/bash

# 定义输出目录
output_dir="mp3"

# 检查是否有输入参数
if [ "$#" -eq 0 ]; then
  # 没有参数，遍历当前目录下的所有.m4a文件
  if [ ! -d "$output_dir" ]; then
    mkdir "$output_dir"
  fi

  for file in *.m4a; do
    if [ -f "$file" ]; then
      output_file="${output_dir}/${file%.m4a}.mp3"
      ffmpeg -i "$file" -q:a 0 -map a "$output_file"
      if [ $? -eq 0 ]; then
        echo "Conversion completed: $output_file"
      else
        echo "Conversion failed for: $file"
      fi
    fi
  done
else
  # 有参数，转换指定的文件
  input_file="$1"
  output_file="${input_file%.m4a}.mp3"

  # 使用ffmpeg转换文件
  ffmpeg -i "$input_file" -q:a 0 -map a "$output_file"

  # 检查转换是否成功
  if [ $? -eq 0 ]; then
    echo "Conversion completed: $output_file"
  else
    echo "Conversion failed for: $input_file"
  fi
fi
