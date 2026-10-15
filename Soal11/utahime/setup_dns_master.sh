#!/bin/bash
# Soal 11 - Setup BIND9 DNS Master pada utahime (10.83.1.2)

echo "[*] Menginstal dan mengonfigurasi BIND9 di utahime..."
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update && apt-get install -y bind9 bind9utils dnsutils

mkdir -p /etc/bind/jujutsu

cat << 'EOF' > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    allow-query { any; };
    dnssec-validation no;
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF

cat << 'EOF' > /etc/bind/named.conf.local
zone "jujutsu.k39.com" {
    type master;
    file "/etc/bind/jujutsu/jujutsu.k39.com";
    notify yes;
    allow-transfer { 10.83.1.3; };
    also-notify { 10.83.1.3; };
};
EOF

cat << 'EOF' > /etc/bind/jujutsu/jujutsu.k39.com
$TTL    604800
@       IN      SOA     utahime.jujutsu.k39.com. root.jujutsu.k39.com. (
                        2026101501      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@       IN      NS      utahime.jujutsu.k39.com.
@       IN      NS      shoko.jujutsu.k39.com.
utahime IN      A       10.83.1.2
shoko   IN      A       10.83.1.3
@       IN      A       10.83.1.4
EOF

chown -R bind:bind /etc/bind/jujutsu
named-checkconf
named-checkzone jujutsu.k39.com /etc/bind/jujutsu/jujutsu.k39.com
service named restart 2>/dev/null || service bind9 restart
echo "[+] DNS Master utahime berhasil dikonfigurasi!"