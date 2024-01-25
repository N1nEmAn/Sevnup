# Sevnup MIPSel Firmware Simulation Tool

## Introduction

Welcome to my script, designed specifically for Arch Linux. Other tools were not fully functional on this system, which was quite frustrating.

This is officially my first time uploading my tool to GitHub. I hope you all give it a star, and feel free to raise any issues!

from 2024.1.24 N1nEmAn

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

5.use`gdb-multiarch`to debug,command as follow:
```sh
#if not install,install first
yay -S gdb-multiarch
#run as follow
gdb-multiarch
#then run as follow to debug kernel
target remote :1234
file {here fill in the location of the two kernels} {here fill in the location of the program you need to debug(if any)}
```
if you need to debug the program running in the virtual machine, you need to break at the address inside the program, and then break at the function name, and continue over. This is the operation of gdb, so I won't go into details.
