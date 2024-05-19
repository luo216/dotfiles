# arch linux install

<!-- vim-markdown-toc GFM -->

* [前期准备](#前期准备)
* [开始安装](#开始安装)
  * [paru（aur helper）](#paruaur-helper)
  * [快速搭建gui](#快速搭建gui)

<!-- vim-markdown-toc -->

## 前期准备

- 下载arch linux的iso镜像（这个一般是live cd）
- 下载ventoy,格式化u盘，将iso镜像丢入u盘即可
- 进入live cd,在/etc/pacman.d/mirrorlist中添加镜像
```shell
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```
- 运行archinstall,可以在预装git vim wget curl

chroot 到 arch上
- vim /etc/pacman.conf 取消 Color前的注释
- vim /etc/pacman.d/mirrorlist 注释掉我们添加的镜像前的地址

## 开始安装

###  paru（aur helper）

- 依赖：git wget curl (base-devel已有)
- 也可以使用yay但是基于golang需要设置一个代理
```shell
export GOPROXY=https://goproxy.cn
```
```shell
mkdir Software
cd Software
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

- 设置一下git本地信息
```shell
git config --global user.name 'steve'
git config --global user.email 'example.com'
```

```shell
paru -S lazygit neofetch
```

### 快速搭建gui

```shell
paru -S dwm dmenu st surf openssh
paru -S lightdm lightdm-gtk-greeter
paru -S waterfox-bin xray-bin v2raya-bin
sudo systemctl enable lightdm --now
sudo systemctl enable sshd --now
sudo systemctl enable v2raya --now
paru -S wqy-zenhei ttf-hack-nerd
paru -S xorg yazi
```

```shell
git clone https://github.com/luo216/dwm  st surf dotfiles
sudo make clean install
```
- 将dotfiles里面的东西拿出来
```shell
paru -S flameshot kitty ueberzugpp feh rofi lemonade-bin picom-simpleanims-next-git
```

```shell
paru -S arandr dunst zsh oh-my-zsh zsh-autosuggestions zsh-syntax-highlighting
chsh -s /bin/zsh
```
