# Hasee 重装系统实施笔记（Arch Linux + Home Manager）

---

## 一、准备工作

### 下载工具

- Arch Linux ISO 镜像
- Ventoy（推荐）或使用 dd 烧录

### 制作启动盘

```bash
# Ventoy 方式：将 ISO 拖入 U 盘即可

# dd 烧录方式
sudo dd if=/path/to/archlinux.iso of=/dev/sdX bs=4M status=progress && sync
```

---

## 二、基础系统安装

### 连接 WiFi

```bash
iwctl
station wlan0 scan
station wlan0 get-networks
station wlan0 connect <网络名称>
exit

pacman -Sy
```

### 优化镜像源（如果网络慢）

```bash
vim /etc/pacman.d/mirrorlist
# 将中国镜像源移到最上方，例如：
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch

pacman -Sy
```

### 安装 archinstall

```bash
pacman -S archinstall
archinstall
```

### archinstall 配置选项

| 选项 | 推荐值 | 说明 |
|------|--------|------|
| Archinstall language | English | 不用动 |
| Mirrors | Defined | 设置镜像，回车进去改成 China |
| Locales | Defined | 不用动 |
| Disk configuration | Defined | 使用 best layout (ext4)，不要选择 /home 单独分区 |
| Disk encryption | - | 给磁盘加密，不懂就不动 |
| Bootloader | Efistub | 直接使用 UEFI 启动，习惯 grub 就用 grub |
| Unified kernel images | True | UKI + Efistub，无需 bootloader，内核参数通过 /etc/kernel/cmdline 管理 |
| Swap | True | 开启交换分区 |
| Hostname | Hasee | 设置主机名，一般用电脑型号 |
| Root password | 设置密码 | |
| User account | 1 User(s) | 添加一个普通用户，设置密码，并给 super 权限 |
| Profile | Xorg | xorg 和 intel 驱动（视情况调整） |
| Audio | pipewire | |
| Kernels | Linux | 可以试试 zen |
| Additional packages | Defined | vim git wget curl，不要加太多安装会变慢 |
| Network configuration | Use NetworkManager | 个人喜好，gnome 用的也是这个 |
| Timezone | Asia/Shanghai | 时区 |
| Automatic time sync (ntp) | True | ntp 自动同步，不用动 |
| Optional repositories | multilib | 这个加了才能运行一些 32 位的软件，testing 是测试版 |

点击 **Install** 开始安装。

---

## 三、重启后基础配置

### 连接网络

```bash
nmtui
```

### 更新系统

```bash
sudo pacman -Syu
```

### 启用 SSH

```bash
sudo pacman -S openssh
sudo systemctl enable sshd --now
```

### 配置 pacman

```bash
sudo vim /etc/pacman.conf
# 取消 Color 前的注释（彩色输出）
```

### 设置中文环境

```bash
sudo vim /etc/locale.gen
# 取消 zh_CN.UTF-8 前的 # 注释
sudo locale-gen
sudo localectl set-locale LANG=zh_CN.UTF-8
```

### 安装 AUR 助手（paru）

```bash
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru
```

---

## 四、硬件驱动配置

### Intel 核显硬件加速

```bash
sudo pacman -S intel-media-driver libva-utils
# 验证：vainfo
```

### 摄像头支持

```bash
sudo pacman -S v4l-utils
# 验证：v4l2-ctl --list-devices
```

### 打印机支持（可选）

```bash
sudo pacman -S cups cups-pdf
sudo systemctl enable cups --now
```

### 其他外设（可选）

```bash
# 串口设备（Arduino 等开发板）pacman没有后期再考虑
# sudo pacman -S arduino-serial-port
# sudo pacman -S arduino-ide

# Android 设备 MTP 支持
sudo pacman -S android-file-transfer
```

---

## 五、休眠配置

### 配置休眠(必须是硬盘swap)

```bash
# 查看 swap 分区
swapon --show

# 在内核参数中添加 resume
sudo nvim /etc/kernel/cmdline
# 添加：resume=UUID=<swap-UUID>

# 重新生成 UKI
sudo reinstall-kernels

# 更新 mkinitcpio（如果 resume 不在 HOOKS 中）
sudo nvim /etc/mkinitcpio.conf
# 确保 HOOKS 中包含 resume
HOOKS=(... resume ...)
```

> **提示**：使用 `lsblk -no UUID /dev/sda2` 获取 swap 分区的 UUID

---

## 六、安装 Nix 和 Home Manager

### 安装 Nix

```bash
curl -L https://nixos.org/nix/install | sh -s -- --daemon
```

安装完成后，重新打开终端或执行：

```bash
source ~/.nix-profile/etc/profile.d/nix.sh
```

### 配置 Flakes 和 Trusted User

```bash
# 创建用户级配置目录
mkdir -p ~/.config/nix

# 启用 Flakes（用户级）
cat >> ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
EOF

# 设置当前用户为 trusted user（需要 sudo）
sudo bash -c 'echo "trusted-users = steve" >> /etc/nix/nix.conf'

# 启用自动优化 Nix store（节省磁盘空间）
sudo bash -c 'echo "auto-optimise-store = true" >> /etc/nix/nix.conf'

# 重启 nix-daemon 服务
sudo systemctl restart nix-daemon
```

### 克隆配置仓库

```bash
mkdir -p ~/Data
cd ~/Data
git clone https://github.com/luo216/nix-config
cd nix-config
```

### 安装 Home Manager 并应用配置

```bash
nix run github:nix-community/home-manager -- switch --flake .#steve@hasee
```

---

## 七、系统级配置（Home Manager 外）

### 安装系统包

```bash
# 显示管理器
sudo pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
# 蓝牙
sudo pacman -S blueman bluez-utils
# 省电
sudo pacman -S tlp tlp-rdw
# U 盘挂载
sudo pacman -S udisks2
# NVIDIA 驱动
sudo pacman -S nvidia-open
#（可选，双显卡切换)
paru -S optimus-manager  optimus-manager-qt
# polkit 认证代理
paru -S xfce-polkit
# shell
sudo pacman -S zsh
chsh -s /usr/bin/zsh
```

> **说明**：
>
> - udisks2：系统级 D-Bus 服务，用户级自动挂载由 Home Manager 的 `services.udiskie` 管理
> - xfce-polkit：图形化权限提升，在 autostart.sh 中启动
> - nvidia + optimus-manager：双显卡切换，日常使用 Intel 核显可不安装

### 启用系统服务

```bash
sudo systemctl enable lightdm --now        # 显示管理器
sudo systemctl enable bluetooth --now      # 蓝牙
sudo systemctl enable tlp --now            # 省电
sudo systemctl enable udisks2 --now        # U 盘挂载
sudo systemctl enable optimus-manager      # NVIDIA 显卡切换（如已安装）
```

### 配置 paru（先复制原版再修改）

```bash
mkdir -p ~/.config/paru
cp /etc/paru.conf ~/.config/paru/paru.conf

# 编辑配置，取消注释需要的选项

vim ~/.config/paru/paru.conf

# 例如：取消 BottomUp 的注释，在 [bin] 节添加 FileManager = yazi
```

### 配置自动登录

```bash
sudo groupadd -r autologin
sudo gpasswd -a steve autologin
sudo vim /etc/lightdm/lightdm.conf
# 设置：autologin-user=steve
```

### 配置电源按键防误触

```bash
sudo vim /etc/systemd/logind.conf
# 设置：HandlePowerKey=ignore
```

### 添加用户到 video 组（亮度控制）

```bash
sudo gpasswd -a steve video
```

### 配置苹果键盘（可选）

```bash
sudo vim /etc/modprobe.d/hid_apple.conf
# 添加以下内容：
options hid_apple fnmode=2
options hid_apple swap_opt_cmd=1
options hid_apple swap_fn_leftctrl=1
```

> **说明**：
> - `fnmode=2` Fn 键作为功能键
> - `swap_opt_cmd=1` 交换 Option 和 Command 键
> - `swap_fn_leftctrl=1` 交换 Fn 和左 Ctrl 键

---

## 八、数据盘挂载与软链接

### 挂载数据盘

```bash
# 创建挂载点
sudo mkdir -p /data

# 查看数据盘设备名
lsblk

# 先分区
sudo fdisk /dev/sdb
# 进去后按m有教程

# 假设数据盘是 /dev/sdb1，格式化（如果是新盘）
sudo mkfs.ext4 /dev/sdb1

# 获取 UUID 并添加到 fstab
lsblk -no UUID /dev/sdb1
sudo vim /etc/fstab

# 添加：
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /data ext4 defaults,noatime 0 2
# 简单解释一下参数：
# noatime：不记录文件访问时间，能减少磁盘写入，对 SSD 很友好。
# 0：不需要 dump 备份。
# 2：挂载点不是根目录，所以文件系统检查顺序设为 2。


# 挂载
# 1. 刷新配置
sudo systemctl daemon-reload

# 2. 挂载（如果没有报错就是成功了）
sudo mount /data

# 3. 验证是否挂载成功
df -h | grep data

# 设置权限
sudo chown -R steve:steve /data
```

### 创建软链接

```bash
# 在数据盘创建目录
mkdir -p /data/{Data,Documents,Downloads,Music,Pictures,Videos,Softwares,Workspace}

# 备份并删除原有目录，创建软链接
cd ~
rm -rf Data Documents Downloads Music Pictures Videos Softwares Workspace  # 注意：会删除原有数据！
ln -s /data/Data Data
ln -s /data/Documents Documents
ln -s /data/Downloads Downloads
ln -s /data/Music Music
ln -s /data/Pictures Pictures
ln -s /data/Videos Videos
ln -s /data/Softwares Softwares
ln -s /data/Workspace Workspace
```

> **说明**：
>
> - `defaults,noatime` 减少磁盘写入，延长 SSD 寿命
> - 软链接将占用空间大的目录指向数据盘，节省系统盘空间
> - 创建软链接前请确保已备份原有数据
> - **注意**：Home Manager 的 `xdg.userDirs` 会在软链接存在时正常工作，无需修改配置

---

## 九、完成

```bash
sudo reboot
```

系统重启后，Home Manager 配置会自动生效。

---

## 十、补充配置

### 安装 LazyVim

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

### 安装系统字体

```bash
paru -S wqy-microhei
```

> **说明**：避免部分软件无法读取 nix 安装的字体

### 复制配置文件

将 `config` 目录中的 dwm 配置复制到相应位置即可。

---
