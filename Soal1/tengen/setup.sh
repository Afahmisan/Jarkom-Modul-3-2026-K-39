#!/bin/bash
# Soal 1 - Setup Static IP tengen (10.83.4.10/24)

echo "[*] Setting static IP on tengen..."

cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.83.4.10
    netmask 255.255.255.0
    gateway 10.83.4.1
EOF

cat << 'EOF' > /root/init.sh
#!/bin/bash
ip link set eth0 up
ip addr flush dev eth0 2>/dev/null || true
ip addr add 10.83.4.10/24 dev eth0
ip route replace default via 10.83.4.1
EOF

chmod +x /root/init.sh
/root/init.sh

echo "nameserver 10.83.4.1" > /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

echo "[+] Konfigurasi tengen berhasil!"
ip -brief a show eth0
ip route show
