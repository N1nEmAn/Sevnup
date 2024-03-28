# Sevnup MIPSel Firmware Simulation Tool

## Introduction

Welcome to my script, designed specifically for **Arch Linux**. Other tools were not fully functional on this system, which was quite frustrating.

This is officially my first time uploading my tool to GitHub. I hope you all give it a star, and feel free to raise any issues!

from 2024.1.24 N1nEmAn

The current simulation tools such as FirmAE and FAT are very convenient, but sometimes, some new firmware requires a higher level of DIY simulation. This open-source project is based on Archlinux and is configured directly from the QEMU level. It can be booted into the file system without manual operations and retains a high level of customization. Contributions of other system versions are also welcome. IoTSec FoR FUN!

from 2024.3.28 N1nEmAn

```
   ███████╗███████╗██╗   ██╗███╗   ██╗██╗   ██╗██████╗ 
   ██╔════╝██╔════╝██║   ██║████╗  ██║██║   ██║██╔══██╗
   ███████╗█████╗  ██║   ██║██╔██╗ ██║██║   ██║██████╔╝
   ╚════██║██╔══╝  ╚██╗ ██╔╝██║╚██╗██║██║   ██║██╔═══╝ 
   ███████║███████╗ ╚████╔╝ ██║ ╚████║╚██████╔╝██║     
   ╚══════╝╚══════╝  ╚═══╝  ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     
```

## Features

This tool currently provides simulation of MIPSel firmware file systems. As I delve deeper into IoT security, more features will be developed in the future. Stay tuned!

## Dependencies

Before using this script, make sure you have the following components installed:

- [QEMU](https://www.qemu.org/)

  ```bash
  yay -S qemu-user-static
  ```

- [tunctl](https://tunctl.sourceforge.net/) (from the `uml_utilities` package)

  ```bash
  yay -S uml_utilities
  ```

- [Python 3](https://www.python.org/)

  ```bash
  sudo pacman -S python
  ```

## Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/N1nEmAn/Sevnup.git
   cd Sevnup
   ```

2. Run the script with the path to the squashfs-root as an argument:

   ```bash
    #At first it will download images
   ./run.sh /path/to/squashfs-root
   ```

3. Follow the instructions provided by the script.


4. If other steps are completed, you can run test.py to test whether it is successful.

5. use`gdb-multiarch`to debug,command as follow:

   ```sh
   #if not install,install first
   yay -S gdb-multiarch
   #run as follow
   gdb-multiarch
   #then run as follow to debug kernel
   set architecture {arch}
   file {here fill in the location of the kernel} {here fill in the location of the program you need to debug(if any)}
   target remote :1234
   ```

   

   if you need to debug the program running in the virtual machine, you need to break at the address inside the program, and then break at the function name, and continue over. This is the operation of gdb, so I won't go into details.
## Example
Here is a simple example provided for everyone's reference and convenience of use.
- Quick tip: In the QEMU window, you can use Ctrl + Alt + + to zoom in the window.

![image](https://github.com/GitHubDaily/GitHubDaily/assets/118088443/70b29624-d56b-459f-aa69-0d1b7a55aeb6)
![image](https://github.com/GitHubDaily/GitHubDaily/assets/118088443/dfc52097-8e94-48a2-834e-6eeedef28c34)
![image](https://github.com/GitHubDaily/GitHubDaily/assets/118088443/0cf45988-7840-4657-a531-a5dd74d3f71c)
![image](https://github.com/GitHubDaily/GitHubDaily/assets/118088443/affb3205-98ff-4952-96ab-1c719241c3f3)
![netcore](https://github.com/GitHubDaily/GitHubDaily/assets/118088443/207b386f-86aa-4f46-b62e-184ee0515575)


