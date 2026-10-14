#!/bin/bash
# Soal 2 - Instalasi & Setup ISC DHCP Server pada Tengen

echo "[*] Menyiapkan package isc-dhcp-server..."
mkdir -p /root/packages
if ls /root/packages/isc-dhcp-server*.deb 1>/dev/null 2>&1; then
    dpkg -i /root/packages/*.deb || apt-get install -f -y
else
    apt-get update && apt-get download isc-dhcp-server || apt-get install -y isc-dhcp-server
    cp /var/cache/apt/archives/*.deb /root/packages/ 2>/dev/null || true
fi

sed -i 's/INTERFACESv4=.*/INTERFACESv4="eth0"/' /etc/default/isc-dhcp-server 2>/dev/null || true
echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

cat << 'EOF' > /etc/dhcp/dhcpd.conf
default-lease-time 3600;
max-lease-time 7200;
authoritative;

option domain-name "k39.com";
option domain-name-servers 10.83.1.2, 10.83.1.3;

# Subnet Data Center (Local)
subnet 10.83.4.0 netmask 255.255.255.0 {
}

# Subnet Divisi A (Relayed)
subnet 10.83.2.0 netmask 255.255.255.0 {
    option routers 10.83.2.1;
    option broadcast-address 10.83.2.255;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 10.83.1.2, 10.83.1.3;
    option domain-search "k39.com";
    range 10.83.2.10 10.83.2.95;
}

# Subnet Divisi B (Relayed)
subnet 10.83.3.0 netmask 255.255.255.0 {
    option routers 10.83.3.1;
    option broadcast-address 10.83.3.255;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 10.83.1.2, 10.83.1.3;
    option domain-search "k39.com";
    range 10.83.3.10 10.83.3.199;
}
EOF

cp /etc/dhcp/dhcpd.conf /root/dhcpd.conf
touch /var/lib/dhcp/dhcpd.leases
service isc-dhcp-server restart
echo "[+] ISC-DHCP-Server Tengen berjalan!"
service isc-dhcp-server status
