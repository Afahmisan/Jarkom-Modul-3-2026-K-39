#!/bin/bash
# Soal 12 - Update Slave Reverse Zone & Forwarder pada shoko

cat << 'EOF' > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    forwarders {
        192.168.122.1;
    };
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

zone "1.83.10.in-addr.arpa" {
    type slave;
    masters { 10.83.1.2; };
    file "/var/lib/bind/1.83.10.in-addr.arpa";
};
EOF

chown -R bind:bind /var/lib/bind
service named restart 2>/dev/null || service bind9 restart
echo "[+] Update DNS Slave shoko selesai!"