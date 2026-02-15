#!/bin/sh

music_dir="$HOME/Music"
video_dir="/tmp/bbdown-video/"

# 函数：下载视频并播放
download_and_play_video() {
  local video_id="$1"
  rm -rf "$video_dir"
  mkdir -p "$video_dir"
  cd "$video_dir"
  notify-send "Downloading video..."
  if BBDown -dd "$video_id"; then
    notify-send "Video downloaded successfully."
    mpv ./* &> /dev/null &
  else
    notify-send "Failed to download video."
  fi
}

# 函数：下载音频
download_audio() {
  local audio_id="$1"
  cd "$music_dir"
  if BBDown --audio-only "$audio_id"; then
    notify-send "Audio downloaded successfully."
  else
    notify-send "Failed to download audio."
  fi
}

# 检查是否提供了一个URL
if [ -z "$1" ]; then
  sleep 0.1
  video_id=$(rofi -dmenu -i -p "Enter your Bilibili video URL: ")
  download_and_play_video "$video_id"
else
  audio_id="$1"
  download_audio "$audio_id"
fi
