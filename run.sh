#!/bin/bash

# Set the function to clean up upon exit
cleanup() {
  echo -e "\n\033[0;33m[!]\033[0m Cleaning up resources..."
  # Stop the HTTP server if it's running
  if pgrep -f "python3 -m http.server" >/dev/null; then
    echo -e "[o] Stopping HTTP server on port 8000..."
    sudo fuser -k 8000/tcp 2>/dev/null
    if pgrep -f "python3 -m http.server" >/dev/null; then
      echo -e "\033[0;31m[x]\033[0m Failed to stop HTTP server"
    else
      echo -e "\033[0;32m[+]\033[0m HTTP server stopped successfully"
    fi
  fi
  # Remove the HTTP log file
  if [ -f "/etc/qemu-ifup.bak" ]; then
    echo -e "[o] Restoring original QEMU network script..."
    sudo mv /etc/qemu-ifup.bak /etc/qemu-ifup
    echo -e "\033[0;32m[+]\033[0m Original QEMU network script restored"
  fi

  # Remove the tap0 network interface
  if ip link show tap0 &>/dev/null; then
    echo -e "[o] Removing tap0 network interface..."
    sudo ip link set tap0 down
    sudo ip tuntap del mode tap name tap0
    if ! ip link show tap0 &>/dev/null; then
      echo -e "\033[0;32m[+]\033[0m tap0 interface removed successfully"
    else
      echo -e "\033[0;31m[x]\033[0m Failed to remove tap0 interface"
    fi
  fi

  echo -e "\033[0;32m[+]\033[0m Cleanup completed"
}
trap cleanup EXIT

# Print ASCII art at the beginning
echo "                                                    "
echo "     ███████╗███████╗██╗   ██╗███╗   ██╗██╗   ██╗██████╗ "
echo "     ██╔════╝██╔════╝██║   ██║████╗  ██║██║   ██║██╔══██╗"
echo "     ███████╗█████╗  ██║   ██║██╔██╗ ██║██║   ██║██████╔╝"
echo "     ╚════██║██╔══╝  ╚██╗ ██╔╝██║╚██╗██║██║   ██║██╔═══╝ "
echo "     ███████║███████╗ ╚████╔╝ ██║ ╚████║╚██████╔╝██║     "
echo "     ╚══════╝╚══════╝  ╚═══╝  ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     "
echo "                                                    "
echo "     Welcome to Sevnup firmware analysis script for MIPS/ARM "
echo "   By N1nEmAn - https://github.com/N1nEmAn/Sevnup"
echo "                                                    "

# Display help information
print_help() {
  echo "Usage: $0 [ARCHITECTURE] [ROOT_PATH]"
  echo
  echo "ARCHITECTURE:"
  echo "  mipsel   - MIPS Little Endian architecture"
  echo "  mips     - MIPS Big Endian architecture"
  echo "  armel    - ARMel architecture"
  echo "  armhf    - ARMhf architecture for vexpress"
  echo
  echo "ROOT_PATH:"
  echo "  The path to the root directory of the squashfs-root."
  echo
  echo "Example:"
  echo "  $0 mips /path/to/squashfs-root"
  exit 1
}

# Check for arguments
if [ "$#" -ne 2 ]; then
  echo -e "\033[0;31m[x]\033[0m Invalid number of arguments."
  print_help
fi

# Check for architecture argument
arch="$1"
if [ "$arch" != "mipsel" ] && [ "$arch" != "mips" ] && [ "$arch" != "armel" ] && [ "$arch" != "armhf" ]; then
  echo -e "\033[0;31m[x]\033[0m Unsupported architecture: $arch"
  print_help
fi
# Check for root path argument
squashfs_root_path="$2"
if [ ! -d "$squashfs_root_path" ]; then
  echo -e "\033[0;31m[x]\033[0m The provided path is not a directory."
  print_help
fi
sudo chmod -R 777 "$squashfs_root_path/lib" 2>/dev/null
sudo chmod -R 777 "$squashfs_root_path/bin" 2>/dev/null
sudo chmod -R 777 "$squashfs_root_path/sbin" 2>/dev/null
sudo chmod -R 777 "$squashfs_root_path/usr/lib" 2>/dev/null
sudo chmod -R 777 "$squashfs_root_path/usr/bin" 2>/dev/null
sudo chmod -R 777 "$squashfs_root_path/usr/sbin" 2>/dev/null
# Initial log file
mkdir -p log
qemu_log="./log/qemu.log"
tar_log="./log/tar.log"
http_log="./log/http.log"
touch "$qemu_log" "$tar_log" "$http_log"

# Check if vmlinuz and debian images exist
echo "                                                    "
echo "===============check image====================="
echo "                                                    "
if [ "$arch" == "armhf" ]; then
  # Check and download ARMHF files
  if [ ! -f "./img/debian_wheezy_armhf_standard.qcow2" ] || [ ! -f "./img/vmlinuz-3.2.0-4-vexpress" ] || [ ! -f "./img/initrd.img-3.2.0-4-vexpress" ]; then
    echo -e "\033[0;33m[!]\033[0m Downloading required ARMHF files..."
    wget -P ./img https://people.debian.org/~aurel32/qemu/armhf/debian_wheezy_armhf_standard.qcow2
    wget -P ./img https://people.debian.org/~aurel32/qemu/armhf/vmlinuz-3.2.0-4-vexpress
    wget -P ./img https://people.debian.org/~aurel32/qemu/armhf/initrd.img-3.2.0-4-vexpress
    qemu-img resize ./img/debian_wheezy_armhf_standard.qcow2 32G
  fi

elif [ "$arch" == "armel" ]; then
  # Check and download ARMEL files
  if [ -f ./img/vmlinuz-3.2.0-4-versatile ]; then
    echo -e "\033[0;32m[+]\033[0m vmlinuz-3.2.0-4-versatile exists."
  else
    echo -e "\033[0;31m[x]\033[0m vmlinuz-3.2.0-4-versatile is missing. Downloading..."
    wget -P ./img https://people.debian.org/~aurel32/qemu/armel/vmlinuz-3.2.0-4-versatile
    wget -P ./img https://people.debian.org/~aurel32/qemu/armel/initrd.img-3.2.0-4-versatile
    echo "[o] vmlinuz-3.2.0-4-versatile is downloading..."
  fi

  if [ -f ./img/debian_wheezy_armel_standard.qcow2 ]; then
    echo -e "\033[0;32m[+]\033[0m debian_wheezy_armel_standard.qcow2 exists."
  else
    echo -e "\033[0;31m[x]\033[0m debian_wheezy_armel_standard.qcow2 is missing. Downloading..."
    wget -P ./img https://people.debian.org/~aurel32/qemu/armel/debian_wheezy_armel_standard.qcow2
    echo "[o] debian_wheezy_armel_standard.qcow2 is downloading..."
  fi
elif [ "$arch" == "mips" ]; then
  # Handle MIPS (Big Endian)
  if [ ! -f ./img/vmlinux-3.2.0-4-4kc-malta-be ]; then
    echo -e "\033[0;31m[x]\033[0m vmlinux-3.2.0-4-4kc-malta (big-endian) is missing. Downloading..."
    wget -P ./img https://people.debian.org/~aurel32/qemu/mips/vmlinux-3.2.0-4-4kc-malta
    mv ./img/vmlinux-3.2.0-4-4kc-malta ./img/vmlinux-3.2.0-4-4kc-malta-be
    echo "[o] vmlinux-3.2.0-4-4kc-malta (big-endian) is downloading..."
  fi

  if [ ! -f ./img/debian_wheezy_mips_standard.qcow2 ]; then
    echo -e "\033[0;31m[x]\033[0m debian_wheezy_mips_standard.qcow2 is missing. Downloading..."
    wget -P ./img https://people.debian.org/~aurel32/qemu/mips/debian_wheezy_mips_standard.qcow2
    echo "[o] debian_wheezy_mips_standard.qcow2 is downloading..."
  fi
else
  # Handle other architectures (e.g., mipsel)
  if [ -f ./img/vmlinux-3.2.0-4-4kc-malta ]; then
    echo -e "\033[0;32m[+]\033[0m vmlinux-3.2.0-4-4kc-malta exists."
  else
    echo -e "\033[0;31m[x]\033[0m vmlinux-3.2.0-4-4kc-malta is missing. Downloading..."
    wget -P ./img https://people.debian.org/~aurel32/qemu/mipsel/vmlinux-3.2.0-4-4kc-malta
    echo "[o] vmlinux-3.2.0-4-4kc-malta is downloading..."
  fi

  if [ -f ./img/debian_wheezy_mipsel_standard.qcow2 ]; then
    echo -e "\033[0;32m[+]\033[0m debian_wheezy_mipsel_standard.qcow2 exists."
  else
    echo -e "\033[0;31m[x]\033[0m debian_wheezy_mipsel_standard.qcow2 is missing. Downloading..."
    wget -P ./img https://people.debian.org/~aurel32/qemu/mipsel/debian_wheezy_mipsel_standard.qcow2
    echo "[o] debian_wheezy_mipsel_standard.qcow2 is downloading..."
  fi
fi

echo "                                                    "

# Extract the last directory name from the root path
folder_name=$(basename "$squashfs_root_path")

# Config ip address for tap0 and http server for download squashfs-root.tar.gz
echo -e "[o] Configuring tap0 interface and HTTP server..."
sudo tunctl -t tap0 -u $(whoami) 2>/dev/null || sudo ip tuntap add mode tap user $(whoami) name tap0 2>/dev/null
ip link show tap0 &>/dev/null || {
  echo -e "\033[0;31m[x]\033[0m Failed to create tap0 interface."
  exit 1
}

ip addr show tap0 | grep -q "10.10.10.1/24" || {
  # 如果没有 IP，则添加 IP
  sudo ip addr add 10.10.10.1/24 dev tap0 || {
    echo -e "\033[0;31m[x]\033[0m Failed to add IP address to tap0."
    exit 1
  }
}
sudo ip link set dev tap0 up
ip addr show tap0

if [ -f "$squashfs_root_path/../squashfs-root.tar.gz" ]; then
  echo -e "\033[0;32m[+]\033[0m squashfs-root.tar.gz already exists. Skipping compression."
else
  # Create a tar.gz archive of the directory and redirect output to log file
  echo -e "[o] creating squashfs-root.tar.gz..."
  tar -zcvf "$squashfs_root_path/../squashfs-root.tar.gz" -C "$squashfs_root_path/../" "$folder_name" >>./log/tar.log 2>&1
fi

# Kill the process which is using port 8000 and set up http
echo -e "[o] kill the process which is using port 8000 and setup http..."
sudo fuser -k 8000/tcp
nohup python3 -m http.server -d "$squashfs_root_path/../" >./log/http.log 2>&1 &
echo "                                                    "

# Backup existing qemu-ifup script and create a new one
echo "                                                    "
echo "===============config and run qemu====================="
echo "                                                    "
sudo mv /etc/qemu-ifup /etc/qemu-ifup.bak

echo -e "[o] creating /etc/qemu-ifup... and backup existing /etc/qemu-ifup to /etc/qemu-ifup.bak"

cat <<'EOF' | sudo tee /etc/qemu-ifup >/dev/null
#!/bin/sh

# ip addr show
# ip link show
cat /etc/qemu-ifup.bak

EOF

sudo chmod +x /etc/qemu-ifup

# Run qemu-system with nohup and redirect output to log/qemu.log
cp ./load_in_mips.sh "$squashfs_root_path/../"
cp ./bridge.sh "$squashfs_root_path/../"
echo -e "\033[0;32m[+]\033[0m now qemu-system-${arch} is running!"
echo -e "[o] in ${arch}, use username 'root' and password 'root' to login."
echo -e "[o] input:'ifconfig eth0 10.10.10.2/24' to config ip address."
echo -e "[o] input:'ping -c 4 10.10.10.1' to test if the connection is successful."
echo -e "[o] input:'wget http://10.10.10.1:8000/load_in_mips.sh' to download script."
echo -e "[o] input:'sh load_in_mips.sh' to finish all the work."
echo "                                                    "
case "$arch" in
"mips")
  sudo qemu-system-mips -M malta \
    -kernel ./img/vmlinux-3.2.0-4-4kc-malta-be \
    -hda ./img/debian_wheezy_mips_standard.qcow2 \
    -append "root=/dev/sda1 console=tty0" -net nic -net tap,ifname=tap0 -s -nographic \
    2>&1 | tee -a "$qemu_log"
  ;;

"armel")
  sudo qemu-system-arm -M versatilepb -nographic \
    -kernel ./img/vmlinuz-3.2.0-4-versatile \
    -initrd ./img/initrd.img-3.2.0-4-versatile \
    -hda ./img/debian_wheezy_armel_standard.qcow2 \
    -append "root=/dev/sda1 console=tty0" -net nic -net tap,ifname=tap0 -s \
    2>&1 | tee -a "$qemu_log"
  ;;

"armhf")
  sudo qemu-system-arm -M vexpress-a9 -nographic \
    -kernel ./img/vmlinuz-3.2.0-4-vexpress \
    -initrd ./img/initrd.img-3.2.0-4-vexpress \
    -drive if=sd,file=./img/debian_wheezy_armhf_standard.qcow2 \
    -append "root=/dev/mmcblk0p2 console=tty0" -net nic -net tap,ifname=tap0 -s \
    2>&1 | tee -a "$qemu_log"
  ;;

*)
  sudo qemu-system-mipsel -M malta \
    -kernel ./img/vmlinux-3.2.0-4-4kc-malta \
    -hda ./img/debian_wheezy_mipsel_standard.qcow2 \
    -append "root=/dev/sda1 console=tty0" -net nic -net tap,ifname=tap0 -s -nographic \
    2>&1 | tee -a "$qemu_log"
  ;;
esac
