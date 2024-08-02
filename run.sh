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
echo "     Welcome to Sevnup firmware analysis script for MIPSel "
echo "   By N1nEmAn - https://github.com/N1nEmAn/Sevnup"
echo "                                                    "

# Display help information
print_help() {
  echo "Usage: $0 [ARCHITECTURE] [ROOT_PATH]"
  echo
  echo "ARCHITECTURE:"
  echo "  mipsel  - MIPS architecture"
  echo "  armel   - ARM architecture"
  echo
  echo "ROOT_PATH:"
  echo "  The path to the root directory of the squashfs-root."
  echo
  echo "Example:"
  echo "  $0 armel /path/to/squashfs-root"
  exit 1
}

# Check for arguments
if [ "$#" -ne 2 ]; then
  echo -e "\033[0;31m[x]\033[0m Invalid number of arguments."
  print_help
fi

# Check for architecture argument
arch="$1"
if [ "$arch" != "mipsel" ] && [ "$arch" != "armel" ]; then
  echo -e "\033[0;31m[x]\033[0m Unsupported architecture: $arch"
  print_help
fi

# Check for root path argument
squashfs_root_path="$2"
if [ ! -d "$squashfs_root_path" ]; then
  echo -e "\033[0;31m[x]\033[0m The provided path is not a directory."
  print_help
fi

# Initial log file
mkdir -p log
qemu_log="./log/qemu.log"
tar_log="./log/tar.log"
touch ./log/qemu.log
touch ./log/tar.log
touch ./log/http.log

# Check if vmlinuz and debian images exist
echo "                                                    "
echo "===============check image====================="
echo "                                                    "

if [ "$arch" == "armel" ]; then
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
else
  if [ -f ./img/vmlinux-3.2.0-4-4kc-malta ]; then
    echo -e "\033[0;32m[+]\033[0m vmlinux-3.2.0-4-4kc-malta exists."
  else
    echo -e "\033[0;31m[x]\033[0m vmlinux-3.2.0-4-4kc-malta is missing. Downloading..."
    wget -P ./img https://people.debian.org/~aurel32/qemu/mipsel/vmlinux-2.6.32-5-4kc-malta
    echo "[o] vmlinux-2.6.32-5-4kc-malta is downloading..."
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
echo -e "[o] config ip address for tap0 and http server..."
sudo tunctl -t tap0 -u $(whoami)
sudo ip addr add 10.10.10.1/24 dev tap0
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

ip addr show
ip link show
cat /etc/qemu-ifup.bak

EOF

sudo chmod +x /etc/qemu-ifup

# Run qemu-system with nohup and redirect output to log/output.log
cp ./load_in_mips.sh "$squashfs_root_path/../"

if [ "$arch" == "armel" ]; then
  sudo nohup qemu-system-arm -M versatilepb -kernel ./img/vmlinuz-3.2.0-4-versatile -initrd ./img/initrd.img-3.2.0-4-versatile -hda ./img/debian_wheezy_armel_standard.qcow2 -append "root=/dev/sda1 console=tty0" -net nic -net tap,ifname=tap0 -s >"$qemu_log" 2>&1 &
  echo -e "\033[0;32m[+]\033[0m now qemu-system-${arch} is running!"
  echo -e "[o] in ${arch}, use username 'root' and password 'root' to login."
else
  sudo nohup qemu-system-mipsel -M malta -kernel ./img/vmlinux-3.2.0-4-4kc-malta -hda ./img/debian_wheezy_mipsel_standard.qcow2 -append "root=/dev/sda1 console=tty0" -net nic -net tap,ifname=tap0 -s >"$qemu_log" 2>&1 &
  echo -e "\033[0;32m[+]\033[0m now qemu-system-${arch} is running!"
  echo -e "[o] in ${arch}, use username 'root' and password 'root' to login."
fi
echo -e "[o] input:'ifconfig eth0 10.10.10.2/24' to config ip address."
echo -e "[o] input:'ping 10.10.10.1' to test if the connection is successful."
echo -e "[o] input:'wget http://10.10.10.1:8000/load_in_mips.sh' to download script."
echo -e "[o] input:'sh load_in_mips.sh' to finish all the work."
echo "                                                    "
