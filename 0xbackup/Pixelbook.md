# pixelbook 装机记录

<!-- vim-markdown-toc GFM -->

* [先正常使用arch install](#先正常使用arch-install)
* [home-manager一整套](#home-manager一整套)
* [安装系统软件](#安装系统软件)
* [系统配置](#系统配置)
* [最后的常用软件](#最后的常用软件)

<!-- vim-markdown-toc -->

##  先正常使用arch install 

> 我这台属于弱机，所以没有lvm和冬眠功能(lvm如果本来就有需要先清理一下,否则archinstall会卡住)
- 重启后的wifi连接使用 nmtui
- 更新一下： sudo pacman -Sy
- 剩下的...... (看正文)

- 开启 openssh:
```shell
sudo pacman -S openssh
sudo systemctl enable sshd --now
```

##  home-manager一整套

- 为了控制变量统一安装官网安装nix
```shell
sh <(curl -L https://nixos.org/nix/install) --daemon
```

- 开启 flake
```shell
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

- 安装 home-manager
```shell
nix profile install github:nix-community/home-manager
```

- 指定设备
>可以直接应用github仓库配置
```language
home-manager switch --no-write-lock-file --flake  github:luo216/nix-config#pixelbook
```

- 也可以clone到本地
```language
git clone https://github.com/luo216/nix-config
home-manager switch --flake .nix-config#pixelbook
```

## 安装系统软件

- 安装paru
```language
cd
mkdir Software
cd Software
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

- 配置一些不适合nix安装的软件
```shell
paru -S dwm yazi zsh light fcitx5-chinese-addons lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings tlp tlp-rdw xfce-polkit blueman bluez-utils udisks2 udiskie

sudo systemctl enable lightdm --now
sudo systemctl enable tlp --now
sudo gpassswd -a $USER video
sudo ln -s /usr/bin/vim /usr/bin/vi
```

## 系统配置

- paru FileManager设置为yazi
> 将[bin]中的FileManager修改为yazi,去掉bin 和 FileManager前的#
```shell
sudo vim /etc/paru.conf
```

- lightdm设置自动登陆
```shell
sudo groupadd -r autologin
sudo gpasswd -a $USER autologin
sudo vim /etc/lightdm/lightdm.conf
```
> 到配置文件中设置autologin-user,美化就不做了，反正不常见

> 重启试试,如果设置了磁盘加密，或者有/home分区的话，就得再想办法了

- github密钥生成
```shell
ssh-keygen -t ed25519 -C "your_email" # 这个强度高
ssh-keygen -t rsa -b 4096 -C "your_email" # 这个强度低一些
```

- 设置中文
```shell
sudo vim /etc/locale.gen
```
> 将zh_CN.UTF-8 前的#去掉
```shell
sudo locale-gen
sudo localectl set-locale LANG=zh_CN.UTF-8
```

- gtk和qt美化
```shell
paru -S whitesur-gtk-theme kvantum-theme-whitesur-git papirus-icon-theme
```
> qt5ct中设置图标主题papirus-dark，kvantum设置风格,lxappearance中设置主题whitesur-dark和图标主题papirus-dark，

- ~/local/bin添加到path
```shell
sudo vim /etc/profile
```

- 设置开关键键防误触

> 设置盒盖不休眠，开机后关机键防止误触（当然长按还是可以强制关机的）
```shell
sudo vim /etc/systemd/logind.conf  # 自己找着设置吧,
```
> 开机键防止误触一般就设置 `HandlePowerKey=ignore`
```shell
[Login]
#NAutoVTs=6
#ReserveVT=6
#KillUserProcesses=no
#KillOnlyUsers=
#KillExcludeUsers=root
#InhibitDelayMaxSec=5
#UserStopDelaySec=10
#SleepOperation=suspend-then-hibernate suspend
#HandlePowerKey=poweroff
#HandlePowerKeyLongPress=ignore
#HandleRebootKey=reboot
```

## 最后的常用软件

- 云同步 rslsync
```shell
paru -S rslsync
sudo gpasswd -a $USER rslsync #将用户添加入rslsync用户组
mkdir -p ~/.config/rslsync
rslsync --dump-sample-config > ~/.config/rslsync/rslsync.conf # 生成配置
systemctl --user enable rslsync --now # 启动
```
> 然后按照教程走就好了

- kdeconnect
```shell
paru -S kdeconnect
```

- todesk
```shell
paru -S todesk
sudo systemctl start todeskd
sudo systemctl enable todeskd
```

- wps
```language
paru -S wps-office-mui-zh-cn wps-office-cn ttf-wps-fonts
```
