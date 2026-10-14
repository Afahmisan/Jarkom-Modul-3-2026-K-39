#!/bin/bash
# Soal 4 - Pembagian Class Divisi A pada Tengen

cat << 'EOF' > /etc/dhcp/dhcpd.conf
default-lease-time 3600;
max-lease-time 7200;
authoritative;

option domain-name "k39.com";
option domain-name-servers 10.83.1.2, 10.83.1.3;

# Definisi Class Divisi A
class "dev-pool1" {
    match pick-first-value (option dhcp-client-identifier, hardware);
}

class "support-pool2" {
    match pick-first-value (option dhcp-client-identifier, hardware);
}

# Subclass MAC Address Klien
subclass "dev-pool1" 1:02:42:42:d5:6f:00; # itadori
subclass "dev-pool1" 1:02:42:c3:08:31:00; # fushiguro

subclass "support-pool2" 1:02:42:17:32:85:00; # zenin
subclass "support-pool2" 1:02:42:89:fa:de:00; # okkotsu

# Subnet Lokal Data Center
subnet 10.83.4.0 netmask 255.255.255.0 {
}

# Subnet Divisi A (Network 2)
subnet 10.83.2.0 netmask 255.255.255.0 {
    option routers 10.83.2.1;
    option broadcast-address 10.83.2.255;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 10.83.1.2, 10.83.1.3;
    option domain-search "k39.com";

    # Pool 1 (10.83.2.10 - 10.83.2.35)
    pool {
        allow members of "dev-pool1";
        range 10.83.2.10 10.83.2.35;
        default-lease-time 7200;
        max-lease-time 7200;
    }

    # Pool 2 (10.83.2.70 - 10.83.2.95)
    pool {
        allow members of "support-pool2";
        range 10.83.2.70 10.83.2.95;
        default-lease-time 7200;
        max-lease-time 7200;
    }
}

# Subnet Divisi B (Network 3)
subnet 10.83.3.0 netmask 255.255.255.0 {
    option routers 10.83.3.1;
    option broadcast-address 10.83.3.255;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 10.83.1.2, 10.83.1.3;
    option domain-search "k39.com";
}
EOF

cp /etc/dhcp/dhcpd.conf /root/dhcpd.conf
dhcpd -t -cf /etc/dhcp/dhcpd.conf && service isc-dhcp-server restart
echo "[+] Pool Divisi A berhasil diperbarui!"
