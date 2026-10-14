#!/bin/bash
# Soal 10 - Konfigurasi Autostart DHCP Server Tengen

cat << 'EOF' > /root/init.sh
#!/bin/bash
PREFIX="10.83"

ip link set eth0 up
ip addr flush dev eth0 2>/dev/null || true
ip addr add $PREFIX.4.10/24 dev eth0
ip route replace default via $PREFIX.4.1

# Offline restore isc-dhcp-server
if ! which dhcpd >/dev/null 2>&1; then
    dpkg -i /root/packages/*.deb 2>/dev/null || true
fi

[ -f /root/dhcpd.conf ] && cp /root/dhcpd.conf /etc/dhcp/dhcpd.conf
touch /var/lib/dhcp/dhcpd.leases
service isc-dhcp-server restart 2>/dev/null || true
EOF

chmod +x /root/init.sh

if ! grep -q "/root/init.sh" /root/.bashrc 2>/dev/null; then
    echo "[ -f /root/init.sh ] && /root/init.sh" >> /root/.bashrc
fi

echo "[+] Autostart Tengen berhasil disiapkan!"
