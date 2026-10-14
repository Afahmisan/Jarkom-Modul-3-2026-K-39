#!/bin/bash
# Soal 3 - Setup DHCP Relay pada Router Jichi

echo "[*] Menyiapkan package isc-dhcp-relay..."
mkdir -p /root/packages
if ls /root/packages/isc-dhcp-relay*.deb 1>/dev/null 2>&1; then
    dpkg -i /root/packages/*.deb || apt-get install -f -y
else
    apt-get update && apt-get download isc-dhcp-relay || apt-get install -y isc-dhcp-relay
    cp /var/cache/apt/archives/*.deb /root/packages/ 2>/dev/null || true
fi

cat << 'EOF' > /etc/default/isc-dhcp-relay
SERVERS="10.83.4.10"
INTERFACES="eth1 eth2 eth3 eth4"
OPTIONS=""
EOF

cp /etc/default/isc-dhcp-relay /root/isc-dhcp-relay.default
service isc-dhcp-relay restart
echo "[+] DHCP Relay pada Jichi berhasil diaktifkan!"
service isc-dhcp-relay status
