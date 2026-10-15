#!/bin/bash
# Soal 18 - Konfigurasi Backup Server (kirara) & Passive Health Check pada geto

cat << 'EOF' > /etc/nginx/sites-available/geto_lb
upstream api_cluster {
    server 10.83.4.5 weight=3 max_fails=2 fail_timeout=5s; # nanami (Utama 1)
    server 10.83.4.6 weight=1 max_fails=2 fail_timeout=5s; # todo (Utama 2)
    server 10.83.4.7 backup;                              # kirara (Cadangan)
}

server {
    listen 80;
    server_name jujutsu.k39.com www.jujutsu.k39.com _;

    set_real_ip_from 10.83.1.4;
    real_ip_header X-Forwarded-For;
    real_ip_recursive on;

    location / {
        proxy_pass http://api_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

nginx -t && service nginx restart
echo "[+] Failover Backup kirara dan Health Check pada geto berhasil dikonfigurasi!"