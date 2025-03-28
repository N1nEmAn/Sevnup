# Sevnup 固件模拟脚本

![Platform](https://img.shields.io/badge/platform-Linux-blueviolet)
![Forks](https://img.shields.io/github/forks/N1nEmAn/Sevnup)
![Stars](https://img.shields.io/github/stars/N1nEmAn/Sevnup)
![1](https://github.com/user-attachments/assets/fbf51a08-3b9f-49ac-9321-415b095c629e)

⚙️ **简单配置：** Sevnup 允许您直接从 QEMU 层面进行配置和启动，无需手动操作即可进入文件系统。

🔧 **高度自定义：** 享受高度的自定义空间，使其能够适应更多的固件。

🖥️ **基于 Arch Linux：** 这个开源项目基于 Arch Linux，提供了坚实的基础。但它也可以在其他 Linux 中使用。

🌍 **社区贡献：** 欢迎并鼓励为其他系统版本贡献。

🎉 **IoTSec 为乐趣而生：** 享受物联网安全带来的乐趣和学习！

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

2024.8.1 更新，支持armel。
2024.10.27 更新，支持armhf。
2025.3.24 更新，支持mips。
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
   ./sevnup.sh armel/mipsel /path/to/squashfs-root
   ```

3. 按照脚本提供的说明进行操作即可。


4. 如果其他的步骤完成了，可以运行test.py测试是否成功。

5. 使用`gdb-multiarch`进行调试，命令如下：

   如果需要调试虚拟机内运行的程序，需要在程序内部的地址下断点，然后对函数名进行下断点，continue过去即可。这里是gdb的操作，就不细说了。

   ```sh
   #如果没有安装先安装
   yay -S gdb-multiarch
   #运行如下
   gdb-multiarch
   #然后在内部运行如下即可调试内核
   target remote :1234
   file {这里填写两个内核的位置} {这里填写你需要调试的程序的位置（如果有）}
   ```

   



