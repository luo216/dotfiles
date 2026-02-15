# 软件推荐及安装配置

<!-- vim-markdown-toc GFM -->

* [命令软件TUI](#命令软件tui)
  * [Tmux](#tmux)
  * [Shell脚本](#shell脚本)
  * [lazyvim](#lazyvim)
* [串流软件](#串流软件)
  * [sunshine](#sunshine)
* [备份软件](#备份软件)
  * [timeshift](#timeshift)
* [共享文件夹](#共享文件夹)
  * [rslsync](#rslsync)
* [文件传输](#文件传输)
  * [kdeconnect](#kdeconnect)
* [sing-box客户端](#sing-box客户端)
  * [v2rayN](#v2rayn)
  * [软路由使用homeproxy](#软路由使用homeproxy)
* [视频下载器材](#视频下载器材)
  * [BBDown](#bbdown)
* [视频播放器材](#视频播放器材)
  * [mpv](#mpv)

<!-- vim-markdown-toc -->

## 命令软件TUI

### Tmux

```shell
# 配置文件记得放到.config里面
paru -S tmux
sudo ln -s ~/.config/tmux/plugins/rainbarf/rainbarf /usr/local/bin/rainbarf
```

### Shell脚本

```shell
cp -r ~/Data/dotfiles/Share/Software-Script ~/Software/Script
# 在里面运行setup.sh可以将脚本放到/usr/local/bin
```

### lazyvim

```shell
# aur上下载0.10以上的
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

## 串流软件

### sunshine

[arch linux安装sunshine实现串流](https://dev.leiyanhui.com/arch/moonlight-sunshine-install/)
> 在此基础上还需要开启Avahi服务
```shell
sudo systemctl enable --now avahi-daemon
```

## 备份软件

### timeshift


## 共享文件夹

### rslsync

- 安装
```shell
paru -S rslsync
sudo gpasswd -a $USER rslsync #将用户添加入rslsync用户组
mkdir -p ~/.config/rslsync
rslsync --dump-sample-config > ~/.config/rslsync/rslsync.conf # 生成配置
systemctl --user enable rslsync --now # 启动
```
> 然后按照教程走就好了

## 文件传输

### kdeconnect

## sing-box客户端

### v2rayN

### 软路由使用homeproxy

## 视频下载器材

### BBDown

## 视频播放器材

### mpv
