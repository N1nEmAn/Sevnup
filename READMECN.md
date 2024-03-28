# Sevnup MIPSel 固件模拟脚本

## 介绍

欢迎使用我这个脚本，写这个脚本是专门为archlinux设计的，因为其他的工具我在这个系统无法完全使用，这让我非常难受。

算是我正式第一次在github上传自己的工具吧，希望大家点亮star，如果有什么问题敬请提出！

来自2024.1.24 N1nEmAn

当前FirmAE和FAT等仿真工具非常方便，但是有时候一些新的固件需要更加高度的DIY仿真。本开源项目基于Archlinux,直接从qemu层面配置，启动即可进入文件系统，不需要自己手动操作，并且保留了高度的自定义空间。也欢迎各位贡献其他系统版本。IoTSec FoR FUN！

来自2024.3.28 N1nEmAn

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

5. 使用`gdb-multiarch`进行调试，命令如下：

   如果需要调试虚拟机内运行的程序，需要在程序内部的地址下断点，然后对函数名进行下断点，continue过去即可。这里是gdb的操作，就不细说了。

   ```sh
   #如果没有安装先安装
   yay -S gdb-multiarch
   #运行如下
   gdb-multiarch
   #然后在内部运行如下即可调试内核
   set architecture {模拟的系统架构}
   file {这里填写内核的位置} {这里填写你需要调试的程序的位置（如果有）}
   target remote :1234
   ```
## 例子
这里提供一个例子，方便大家参考和使用。
- 小tips：在qemu窗口使用`ctrl+alt+ +`可以放大窗口。
![image](https://github.com/GitHubDaily/GitHubDaily/assets/118088443/70b29624-d56b-459f-aa69-0d1b7a55aeb6)
![image](https://github.com/GitHubDaily/GitHubDaily/assets/118088443/dfc52097-8e94-48a2-834e-6eeedef28c34)
![image](https://github.com/GitHubDaily/GitHubDaily/assets/118088443/0cf45988-7840-4657-a531-a5dd74d3f71c)
![image](https://github.com/GitHubDaily/GitHubDaily/assets/118088443/affb3205-98ff-4952-96ab-1c719241c3f3)
![成功复现磊科路由器漏洞](https://github.com/GitHubDaily/GitHubDaily/assets/118088443/207b386f-86aa-4f46-b62e-184ee0515575)



