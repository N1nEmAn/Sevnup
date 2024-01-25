ip link add br0 type bridge
ip link set dev br0 up
ip link set dev eth0 master br0
ip address add 10.10.10.2/24 dev br0
ip link set br0 up
