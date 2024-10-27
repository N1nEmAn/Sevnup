# Sevnup Firmware Emulation Script

## Highlight

- ⚙️ **Easy Configuration:** FirmA allows you to configure and start directly from the QEMU layer without manual operations.
- 🔧 **High Customization:** Enjoy a high degree of customization, making it adaptable to a wide range of firmware.
- 🖥️ **Arch Linux Base:** This open-source project is based on Arch Linux, offering a solid foundation.But it can also be used in other Linux.
- 🌍 **Community Contributions:** Contributions for other system versions are welcome and encouraged.
- 🎉 **IoTSec FoR FUN:** Dive into IoT security with enjoyment and learning!

## Introduction

Welcome to my script! This script is specifically designed for Arch Linux because other tools do not work fully on this system, which frustrates me a lot.

This is my official first tool uploaded to GitHub. I hope you will star it, and if you have any questions, feel free to raise them!

From January 24, 2024, N1nEmAn

```
   ███████╗███████╗██╗   ██╗███╗   ██╗██╗   ██╗██████╗ 
   ██╔════╝██╔════╝██║   ██║████╗  ██║██║   ██║██╔══██╗
   ███████╗█████╗  ██║   ██║██╔██╗ ██║██║   ██║██████╔╝
   ╚════██║██╔══╝  ╚██╗ ██╔╝██║╚██╗██║██║   ██║██╔═══╝ 
   ███████║███████╗ ╚████╔╝ ██║ ╚████║╚██████╔╝██║     
   ╚══════╝╚══════╝  ╚═══╝  ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     
```

## Features

Currently, this tool only provides emulation of the MIPSEL firmware file system. As I delve deeper into IoT security, more features will be developed, so stay tuned!

Update on August 1, 2024: Added support for armel.
Update on Oct 27, 2024: Added support for armhf.

## Dependencies

Before using this script, please ensure you have installed the following components:

- [QEMU](https://www.qemu.org/)

  ```bash
  yay -S qemu-user-static
  ```

- [tunctl](https://tunctl.sourceforge.net/) (available from the `uml_utilities` package)

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

2. Run the script and pass the path of the squashfs-root as a parameter:

   ```bash
   # The first run will download the image.
   ./sevnup.sh armel/mipsel /path/to/squashfs-root
   ```

3. Follow the instructions provided by the script.

4. If other steps are completed, you can run `test.py` to test if it was successful.

5. Use `gdb-multiarch` for debugging with the following commands:

   If you need to debug a program running inside the virtual machine, set breakpoints at the program's internal addresses, then set breakpoints at the function names and continue. This is about GDB operations, so I won't go into detail.

   ```sh
   # Install if not already installed
   yay -S gdb-multiarch
   # Run the following
   gdb-multiarch
   # Then run the following internally to debug the kernel
   target remote :1234
   file {fill in the location of the two kernels here} {fill in the location of the program you want to debug (if any)}
   ```
