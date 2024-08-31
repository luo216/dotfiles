# arch linux install

<!-- vim-markdown-toc GFM -->

* [前期准备](#前期准备)
* [系统安装](#系统安装)
* [基础环境搭建](#基础环境搭建)
* [安装图形化界面](#安装图形化界面)
  * [开始美化](#开始美化)
* [杂七杂八](#杂七杂八)
  * [鼠标设置](#鼠标设置)
  * [苹果键盘设置](#苹果键盘设置)
  * [设置开关键键防误触](#设置开关键键防误触)
  * [github密钥生成](#github密钥生成)
* [LVM使用](#lvm使用)
  * [缩小lv](#缩小lv)
  * [增加lv](#增加lv)
  * [创建新lv](#创建新lv)
* [启用Swap](#启用swap)
  * [持久化](#持久化)
* [休眠hibernate设置](#休眠hibernate设置)
* [软件推荐及安装配置](#软件推荐及安装配置)

<!-- vim-markdown-toc -->

## 前期准备

- 下载arch linux的iso镜像（这个一般是live cd）
- 下载ventoy,格式化u盘，将iso镜像丢入u盘即可
> 有的iso无法正常启动，我们可以使用老套的dd烧录
```shell
sudo dd if=/path/to/your/image.iso of=/dev/sdX bs=4M status=progress
```
- 连接wifi,输入iwctl进入交互式提示符（interactive prompt），配置并连接到互联网。
```shell
station wlan0 scan
station wlan0 get-networks
station wlan0 connect <network name>
station wlan0 show
exit　　# 回到命令行
pacman -Sy
```

- 如果pacman -Sy 缓慢或者 archinstall一直在检测状态就是网络不好
```shell
vim /etc/pacman.d/mirrorlist
```
> 自救搜索一个arch linux的镜像源放在最顶上,然后 记得 pacman -Sy 更新一下
```shell
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```

## 系统安装

- 记得安装archinstall,因为它可能不是最新的
```shell
pacman -S archinstall
```

- 执行`archinstall`
```shell
Archinstall language               English                # 不用动
Mirrors                            Defined                # 设置镜像的，回车进去改成china
Locales                            Defined                # 不用动
Disk configuration                 Defined                # 使用best layout(ext4),然后不要选择/home单独分区
Disk encryption                                           # 给磁盘加密的，不懂就不动
Bootloader                         Efistub                # 直接使用uefi启动，习惯grub就用grub
Unified kerrnel images             False                  # 统一内核镜像，使用efistub才有的选项
Swap                               True                   # 开启交换分区
Hostname                           Hasee                  # 设置主机名,我一般用电脑型号
Root password                      *******                # 设置root密码
User account                       1 User(s)              # 添加一个普通用户，设置密码，并给super权限
Profile                            Xorg                   # 我现在xorg和intel驱动(视情况调整)
Audio                              pipewire               # 我老年人，没用过pipewire
Kerrnels                           Linux, linux-zen       # 我一般加一个zen
Additional packages                Defined                # vim git wget curl 不要加太多安装会变慢
Network configuration              Use NetworkManager     # 个人喜好，gnome用的也是这个
Timezone                           Asia/Shanghai          # 时区
Automatic time sync (ntp)          True                   # ntp自动同步，不用动
Optional repositories              multilib               # 这个加了才能运行一些32位的软件,testing是测试版

Install     点击安装即可
```
> UKI提供了一个 /etc/kernel/cmdline

> 如果网络不行，在/etc/pacman.d/mirrorlist中搜索China将看得顺眼镜像移到上方

- chroot 到 arch上
- vim /etc/pacman.conf 取消 Color前的注释
- shotdown -h now 关机后重启

## 基础环境搭建

- 重启后的wifi连接使用 `nmtui`

- 更新一下： `sudo pacman -Sy` 

- opensshd: `sudo pacman -S openssh`
> `sudo systemctl enable sshd --now`

- 初始化git
```shell
git config --global user.name 'YOUR-NAME'
git config --global user.email 'YOUR-EMAIL'
```

- 安装 aur-helper
> paru 相比yay不用设置go代理
```shell
cd
mkdir Software
cd Software
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

- 安装一些小工具
```shell
paru -S neovim lazygit yazi lemonade-bin
paru -S ripgrep fd # yazi相关的小依赖，本身也是非常好用的命令行工具
```

- 下载配置文件
```shell
cd
mkdir Data
cd Data
git clone https://github.com/luo216/dotfiles
```

- 剪切板
```shell
paru -S xclip
sudo cp ~/Data/dotfiles/dotconfig/rofi/rofi /usr/local/bin
```

- 设置zsh
```shell
paru -S zsh oh-my-zsh-git zsh-autosuggestions zsh-syntax-highlighting
cp ~/Data/dotfiles/dotzshrc ~/.zshrc
sudo cp ~/Data/dotfiles/share/usr-share-ohmyzsh-themes/mytheme.zsh-theme /usr/share/oh-my-zsh/themes/
chsh -s /bin/zsh
```
> 重启生效

- 使用lemonade
```shell
ssh -R 2489:127.0.0.1:2489 user@host
```

- paru FileManager设置为yazi
```shell
sudo nvim /etc/paru.conf
```
> 将[bin]中的FileManager修改为yazi,去掉bin 和 FileManager前的#

## 安装图形化界面

- 安装 dwm st surf dmenu
```shell
paru -S dwm st surf dmenu tabbed slock feh
```

- 安装 display manager
```shell
paru -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
sudo systemctl enable lightdm --now
```

- 安装自定义的桌面环境
> 之前的原版安装操作可以防止缺少依赖
```shell
cd ~/Software
git clone https://github.com/luo216/dwm
git clone https://github.com/luo216/st
git clone https://github.com/luo216/surf
git clone https://github.com/luo216/slock
git clone https://github.com/luo216/tabbed
```
- 稍作配置然后编译
> dwm 中的 config.h 设置自己喜欢的快捷键，设置网卡名字，设置温度监控设备的数量
```shell
cd ~/Software/dwm
sudo make clean install
cd ~/Software/st
sudo make clean install
cd ~/Software/surf
sudo make clean install
cd ~/Software/slock
sudo make clean install
cd ~/Software/tabbed
sudo make clean install
```
> 把dotconfig的选择放出来一部分

- 补全一些小组件
```shell
paru -S picom ueberzugpp jq conky rofi dunst libnotify
# fonts
paru -S  wqy-zenhei ttf-hack-nerd ttf-nerd-fonts-symbols ttf-wps-fonts
```

- 设置中文
```shell
sudo nvim /etc/locale.gen
```
> 将zh_CN.UTF-8 前的#去掉
```shell
sudo locale-gen
```

- 环境变量设置
```shell
sudo cp ~/Data/dotfiles/share/etc-environment/environment /etc/environment
```

- 设置中文输入法
```shell
paru -S fcitx5-im fcitx5-chinese-addons fcitx5-configtool fcitx5-qt fcitx5-gtk fcitx5-pinyin-zhwiki
mkdir -p ~/.local/share
cp -r ~/Data/dotfiles/share/dotlocal-share/fcitx5 ~/.local/share/fcitx5
```

- 省电tlp
```shell
paru -S tlp tlp-rdw
sudo systemctl enable tlp --now
```

- 系统托盘程序
```shell
paru -S light xfce-polkit-git blueman bluez-utils pasystray network-manager-applet arandr pcmanfm udisks2 udiskie

sudo systemctl enable bluetooth --now
sudo systemctl enable udisks2 --now
sudo gpasswd -a $USER video
```

- lightdm设置自动登陆
```shell
sudo groupadd -r autologin
sudo gpasswd -a $USER autologin
sudo nvim /etc/lightdm/lightdm.conf
```
> 到配置文件中设置autologin-user

> 重启试试,如果设置了磁盘加密，或者有/home分区的话，就得再想办法了

### 开始美化

- 设置lightdm
```shell
# 将background从dotfiles里面取出放进/usr/share/
sudo cp -r ~/Data/dotfiles/share/usr-share-background /usr/share/background
paru -S adw-gtk-theme 
```
> 到lightdm-gtk-greeter配置文件中设置背景和主题(选择adw-gtk3-dark，greeter有圆角)

> 想要模糊效果的锁屏壁纸用ffmpeg: `ffmpeg -i back.png -filter_complex gblur=sigma=10 blur.png`

- 设置conky
```shell
# conky 的配置文件放好后，设置启动脚本的软链接
sudo ln -s ~/.config/conky/Nashira-Light/start.sh /usr/local/bin/myconky
```

- gtk and qt
```shell
paru -S qt5ct kvantum lxappearance whitesur-gtk-theme papirus-icon-theme
```
> lxappearance 设置gtk主题whitesur-dark,图标主题设置papirus-dark

> qt5ct 设置图标主题papirus-dark

> kvantum 设置qt主题: 点击变更/删除主题 -> 选择KuMojave -> 应用此主题 -> 点击配置当前主题(去掉一些特效,记得保存)

- 每个人都不一样的配置
> 设置config中的dwm/autostart.sh(里面设置分辨率，显示器位置...)

> `~/.config/conky/Nashira-Light/scripts/weather-v2.0.sh` 中设置好自己的 api_key 以及 city_id; `https://openweathermap.org/find` 
## 杂七杂八

### 鼠标设置

- 鼠标大小
```shell
cp ~/Data/dotfiles/dotXresources ~/.Xresources
nvim ~/.Xresources # 进去调鼠标大小，记得重启dwm测试是否生效
```

- 鼠标移动速度
```shell
nvim ~/.config/dwm/autostart.sh
# 这个好像是加速度设置 1 ～ -1
xinput --set-prop "$MOUSE" 'libinput Accel Speed' -0.9
# xinput --set-prop "$MOUSE" 'Coordinate Transformation Matrix' 0.6 0 0 0 0.6 0 0 0 2
```

### 苹果键盘设置
```shell
sudo cp ~/Data/dotfiles/Share/etc-modprode.d/hid_apple.conf /etc/modprobe.d/hid_apple.conf
```

### 设置开关键键防误触

> 设置盒盖不休眠，开机后关机键防止误触（当然长按还是可以强制关机的）
- sudo nvim /etc/systemd/logind.conf ,自己找着设置吧,
- 开机键防止误触一般就设置 `HandlePowerKey=ignore`
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

### github密钥生成
```shell
ssh-keygen -t ed25519 -C "your_email" # 这个强度高
ssh-keygen -t rsa -b 4096 -C "your_email" # 这个强度低一些
```

## LVM使用

### 缩小lv
```shell
e2fsck -f /dev/ArchinstallVg/home #检查ext4是否有损坏
resize2fs /dev/ArchinstallVg/home 70G #调整文件系统大小
lvresize -L 70G /dev/ArchinstallVg/home #调整LVM大小
```

### 增加lv
```shell
lvresize -L +15G /dev/ArchinstallVg/root #先增加lvm分区大小才能修改文件系统
e2fsck -f /dev/ArchinstallVg/root #检查ext4是否有损坏
resize2fs /dev/ArchinstallVg/root #调整文件系统大小
```

### 创建新lv
```shell
lvcreate -L 20G -n swap ArchinstallVg
```

## 启用Swap
```shell
mkswap /dev/ArchinstallVg/swap
swapon /dev/ArchinstallVg/swap
```

### 持久化
```shell
lsblk -no UUID /dev/ArchinstallVg/swap # 查看swap的UUID
```
- 以这个格式写入到/etc/fstab
```shell
UUID=UUID-of-swap-partition   none    swap    sw,pri=1  0 0
```
> 不用uuid也可以

## 休眠hibernate设置

- 其实只要在启动过程中让它从swap从读取就好了
```shell
sudo vim /etc/mkinitcpio.conf
```
> 添加 resume 类似：HOOKS=(base udev autodetect keyboard microcode modconf kms keyboard keymap consolefont block filesystems resume fsck)

## 软件推荐及安装配置

[软件推荐及安装配置](./Software.md)
