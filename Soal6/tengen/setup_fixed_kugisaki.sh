#!/bin/bash
# Soal 6 - Fixed Address Kugisaki (10.83.3.99) pada Tengen

cat >> /etc/dhcp/dhcpd.conf << 'EOF'

# Fixed Address Kugisaki
host kugisaki {
    hardware ethernet 02:42:c1:a8:92:00;
    fixed-address 10.83.3.99;
    option routers 10.83.3.1;
    option domain-name-servers 10.83.1.2, 10.83.1.3;
    option domain-search "k39.com";
}
EOF

cp /etc/dhcp/dhcpd.conf /root/dhcpd.conf
dhcpd -t -cf /etc/dhcp/dhcpd.conf && service isc-dhcp-server restart
echo "[+] Static lease Kugisaki berhasil ditambahkan!"
