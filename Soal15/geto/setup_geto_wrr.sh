#!/bin/bash
# Soal 15 - Setup Internal Load Balancer pada geto (10.83.4.2) dengan WRR 3:1

echo "[*] Menginstal dan mengonfigurasi Nginx Load Balancer di geto..."
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update && apt-get install -y nginx curl

cat << 'EOF' > /etc/nginx/sites-available/geto_lb
upstream api_cluster {
    server 10.83.4.5 weight=3; # nanami (bobot 3)
    server 10.83.4.6 weight=1; # todo (bobot 1)
}

server {
    listen 80;
    server_name jujutsu.k39.com www.jujutsu.k39.com _;

    location / {
        proxy_pass http://api_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

ln -sf /etc/nginx/sites-available/geto_lb /etc/nginx/sites-enabled/geto_lb
rm -f /etc/nginx/sites-enabled/default

nginx -t && service nginx restart
echo "[+] Internal Load Balancer geto berhasil dikonfigurasi!"