#!/bin/bash
# Soal 12 - A Record, CNAME, PTR (Reverse DNS), dan Forwarder pada utahime

echo "[*] Menambahkan DNS Forwarder, CNAME, dan Reverse Zone di utahime..."

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
    type master;
    file "/etc/bind/jujutsu/jujutsu.k39.com";
    notify yes;
    allow-transfer { 10.83.1.3; };
    also-notify { 10.83.1.3; };
};

zone "1.83.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jujutsu/1.83.10.in-addr.arpa";
    notify yes;
    allow-transfer { 10.83.1.3; };
    also-notify { 10.83.1.3; };
};
EOF

cat << 'EOF' > /etc/bind/jujutsu/jujutsu.k39.com
$TTL    604800
@       IN      SOA     utahime.jujutsu.k39.com. root.jujutsu.k39.com. (
                        2026101503      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@       IN      NS      utahime.jujutsu.k39.com.
@       IN      NS      shoko.jujutsu.k39.com.
utahime IN      A       10.83.1.2
shoko   IN      A       10.83.1.3
gojo    IN      A       10.83.1.4
@       IN      A       10.83.1.4
www     IN      CNAME   jujutsu.k39.com.
EOF

cat << 'EOF' > /etc/bind/jujutsu/1.83.10.in-addr.arpa
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
4       IN      PTR     jujutsu.k39.com.
EOF

chown -R bind:bind /etc/bind/jujutsu
named-checkconf
named-checkzone jujutsu.k39.com /etc/bind/jujutsu/jujutsu.k39.com
named-checkzone 1.83.10.in-addr.arpa /etc/bind/jujutsu/1.83.10.in-addr.arpa
service named restart 2>/dev/null || service bind9 restart
echo "[+] Update DNS utahime selesai!"