#!/bin/bash

# Print ASCII art at the beginning
echo "                                                    "
echo "     ███████╗███████╗██╗   ██╗███╗   ██╗██╗   ██╗██████╗ "
echo "     ██╔════╝██╔════╝██║   ██║████╗  ██║██║   ██║██╔══██╗"
echo "     ███████╗█████╗  ██║   ██║██╔██╗ ██║██║   ██║██████╔╝"
echo "     ╚════██║██╔══╝  ╚██╗ ██╔╝██║╚██╗██║██║   ██║██╔═══╝ "
echo "     ███████║███████╗ ╚████╔╝ ██║ ╚████║╚██████╔╝██║     "
echo "     ╚══════╝╚══════╝  ╚═══╝  ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     "
echo "                                                    "
echo "     Welcome to Sevnup firmware analysis script for MIPS "
echo "   By N1nEmAn - https://github.com/N1nEmAn/Sevnup"
echo "                                                    "
echo "[o] loading the firmware into a chroot environment..."

#download the squashfs-root.tar.gz from the router
wget http://10.10.10.1:8000/squashfs-root.tar.gz
wget http://10.10.10.1:8000/bridge.sh

#extract the squashfs-root
mkdir -p log
mkdir -p ./temp_extracted
tar -zxvf squashfs-root.tar.gz -C ./temp_extracted >/dev/null 2>>./log/tar.log
mv ./temp_extracted/* ./squashfs-root
rm -rf ./temp_extracted

#chroot into the firmware
mount -t proc /proc/ ./squashfs-root/proc/
mount -o bind /dev/ ./squashfs-root/dev/
export LD_LIBRARY_PATH=./lib:$LD_LIBRARY_PATH
sh bridge.sh
rm -rf ./squashfs-root/webroot
# rm -rf ./squashfs-root/etc
mkdir ./squashfs-root/webroot
# mkdir ./squashfs-root/etc
ln -s ./squashfs-root/webroot_ro/ ./squashfs-root/webroot
chroot squashfs-root sh
