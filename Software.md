# 软件推荐及安装配置

<!-- vim-markdown-toc GFM -->

* [命令软件TUI](#命令软件tui)
  * [Tmux](#tmux)
  * [Shell脚本](#shell脚本)
  * [lazyvim](#lazyvim)
* [串流软件](#串流软件)
  * [sunshine](#sunshine)

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
