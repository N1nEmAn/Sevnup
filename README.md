# Sevnup MIPSel Firmware Analysis Script

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
