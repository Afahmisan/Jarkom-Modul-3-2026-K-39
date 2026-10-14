#!/bin/bash
# Soal 1 - Setup Router Jichi
# Kelompok K-39 (Prefix: 10.83)

echo "[*] Mengonfigurasi Router Jichi..."

cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 10.83.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.83.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.83.3.1
    netmask 255.255.255.0

auto eth4
iface eth4 inet static
    address 10.83.4.1
    netmask 255.255.255.0
EOF

cat << 'EOF' > /root/init.sh
#!/bin/bash
PREFIX="10.83"

ip link set eth0 up
if [ -f /tmp/gns3/bin/udhcpc ]; then
    /tmp/gns3/bin/udhcpc -i eth0 -n -q 2>/dev/null || true
fi
if ! ip -4 addr show dev eth0 | grep -q "inet"; then
    ip addr add 192.168.122.100/24 dev eth0 2>/dev/null || true
    ip route replace default via 192.168.122.1 2>/dev/null || true
fi

for i in 1 2 3 4; do
    ip link set dev eth$i up
    ip addr flush dev eth$i 2>/dev/null || true
    ip addr add $PREFIX.$i.1/24 dev eth$i
done

iptables -t nat -F 2>/dev/null || true
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1
EOF

chmod +x /root/init.sh
/root/init.sh

echo "nameserver 192.168.122.1" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

echo "[+] Router Jichi berhasil dikonfigurasi!"
ip -brief a
iptables -t nat -L -v -n
