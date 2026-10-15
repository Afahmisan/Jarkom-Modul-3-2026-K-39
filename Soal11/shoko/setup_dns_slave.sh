#!/bin/bash
# Soal 11 - Setup BIND9 DNS Slave pada shoko (10.83.1.3)

echo "[*] Menginstal dan mengonfigurasi BIND9 Slave di shoko..."
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update && apt-get install -y bind9 bind9utils dnsutils

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
    type slave;
    masters { 10.83.1.2; };
    file "/var/lib/bind/jujutsu.k39.com";
};
EOF

chown -R bind:bind /var/lib/bind
named-checkconf
service named restart 2>/dev/null || service bind9 restart
echo "[+] DNS Slave shoko berhasil dikonfigurasi!"