#!/bin/bash
# Soal 16 - Setup Public Reverse Proxy pada gojo (10.83.1.4)

echo "[*] Menginstal dan mengonfigurasi Nginx Reverse Proxy di gojo..."
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update && apt-get install -y nginx curl

cat << 'EOF' > /etc/nginx/sites-available/gojo_proxy
upstream frontend_cluster {
    server 10.83.4.3; # maki
    server 10.83.4.4; # panda
}

server {
    listen 80;
    server_name jujutsu.k39.com www.jujutsu.k39.com;

    location / {
        proxy_pass http://frontend_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /api {
        proxy_pass http://10.83.4.2/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

ln -sf /etc/nginx/sites-available/gojo_proxy /etc/nginx/sites-enabled/gojo_proxy
rm -f /etc/nginx/sites-enabled/default

nginx -t && service nginx restart
echo "[+] Public Reverse Proxy gojo berhasil dikonfigurasi!"