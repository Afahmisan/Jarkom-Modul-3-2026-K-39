#!/bin/bash
# Soal 5 - Durasi Lease Time & Options Divisi B pada Tengen

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

subclass "dev-pool1" 1:02:42:42:d5:6f:00; # itadori
subclass "dev-pool1" 1:02:42:c3:08:31:00; # fushiguro
subclass "support-pool2" 1:02:42:17:32:85:00; # zenin
subclass "support-pool2" 1:02:42:89:fa:de:00; # okkotsu

# Definisi Class Divisi B
class "short-lease" {
    match pick-first-value (option dhcp-client-identifier, hardware);
}

class "long-lease" {
    match pick-first-value (option dhcp-client-identifier, hardware);
}

subclass "short-lease" 1:02:42:2f:09:8e:00; # ino
subclass "short-lease" 1:02:42:57:b1:a6:00; # kusakabe
subclass "short-lease" 1:f2:dd:ec:51:c9:cb; # kusakabe (active)
subclass "long-lease" 1:02:42:94:15:6c:00;  # miwa

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

    pool {
        allow members of "dev-pool1";
        range 10.83.2.10 10.83.2.35;
        default-lease-time 7200;
        max-lease-time 7200;
    }

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

    # Short lease (1800 detik / 30 menit)
    pool {
        allow members of "short-lease";
        range 10.83.3.10 10.83.3.89;
        default-lease-time 1800;
        max-lease-time 1800;
    }

    # Long lease (43200 detik / 12 jam)
    pool {
        allow members of "long-lease";
        range 10.83.3.100 10.83.3.199;
        default-lease-time 43200;
        max-lease-time 43200;
    }
}
EOF

cp /etc/dhcp/dhcpd.conf /root/dhcpd.conf
dhcpd -t -cf /etc/dhcp/dhcpd.conf && service isc-dhcp-server restart
echo "[+] Lease time Divisi B berhasil diperbarui!"
