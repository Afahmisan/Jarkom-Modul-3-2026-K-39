#!/bin/bash
# Soal 10 - Konfigurasi Autostart Router Jichi

cat << 'EOF' > /root/init.sh
#!/bin/bash
PREFIX="10.83"

# NAT Interface
ip link set eth0 up
if [ -f /tmp/gns3/bin/udhcpc ]; then
    /tmp/gns3/bin/udhcpc -i eth0 -n -q 2>/dev/null || true
fi
if ! ip -4 addr show dev eth0 | grep -q "inet"; then
    ip addr add 192.168.122.100/24 dev eth0 2>/dev/null || true
    ip route replace default via 192.168.122.1 2>/dev/null || true
fi

# Interfaces eth1 - eth4
for i in 1 2 3 4; do
    ip link set dev eth$i up
    ip addr flush dev eth$i 2>/dev/null || true
    ip addr add $PREFIX.$i.1/24 dev eth$i
done

# Routing & NAT
iptables -t nat -F 2>/dev/null || true
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1

# Offline package restore if needed
if ! which dhcrelay >/dev/null 2>&1; then
    dpkg -i /root/packages/*.deb 2>/dev/null || true
fi

# Start Relay
service isc-dhcp-relay restart 2>/dev/null || true
EOF

chmod +x /root/init.sh

if ! grep -q "/root/init.sh" /root/.bashrc 2>/dev/null; then
    echo "[ -f /root/init.sh ] && /root/init.sh" >> /root/.bashrc
fi

echo "[+] Autostart Jichi berhasil disiapkan!"
