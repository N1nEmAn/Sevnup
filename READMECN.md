# Sevnup MIPSel 固件模拟脚本

## 介绍

欢迎使用我这个脚本，写这个脚本是专门为archlinux设计的，因为其他的工具我在这个系统无法完全使用，这让我非常难受。

算是我正式第一次在github上传自己的工具吧，希望大家点亮star，如果有什么问题敬请提出！

来自2024.1.24 N1nEmAn

```
   ███████╗███████╗██╗   ██╗███╗   ██╗██╗   ██╗██████╗ 
   ██╔════╝██╔════╝██║   ██║████╗  ██║██║   ██║██╔══██╗
   ███████╗█████╗  ██║   ██║██╔██╗ ██║██║   ██║██████╔╝
   ╚════██║██╔══╝  ╚██╗ ██╔╝██║╚██╗██║██║   ██║██╔═══╝ 
   ███████║███████╗ ╚████╔╝ ██║ ╚████║╚██████╔╝██║     
   ╚══════╝╚══════╝  ╚═══╝  ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     
```

## 功能

本工具目前提供的功能仅限于对mipsel的固件文件系统模拟，后续随着本人对IoT安全的深入学习，会开发更多的功能，敬请期待！

## 依赖

在使用该脚本之前，请确保您已经安装以下组件：

- [QEMU](https://www.qemu.org/)

  ```bash
  yay -S qemu-user-static
  ```

- [tunctl](https://tunctl.sourceforge.net/) (从 `uml_utilities` 包中获取)

  ```bash
  yay -S uml_utilities
  ```

- [Python 3](https://www.python.org/)

  ```bash
  sudo pacman -S python
  ```

## 使用方法

1. 克隆存储库：

   ```bash
   git clone https://github.com/N1nEmAn/Sevnup.git
   cd Sevnup
   ```

2. 运行脚本并传递 squashfs-root 的路径作为参数：

   ```bash
   #第一次运行会下载镜像。
   ./sevnup.sh /path/to/squashfs-root
   ```

3. 按照脚本提供的说明进行操作即可。


4. 如果其他的步骤完成了，可以运行test.py测试是否成功。

