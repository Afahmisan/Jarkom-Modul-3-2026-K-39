#!/bin/bash
# Soal 19 - Proxy Caching (10 menit) & Rate Limiting (10r/s) pada gojo

mkdir -p /var/cache/nginx/frontend_cache
chown -R www-data:www-data /var/cache/nginx
rm -rf /var/cache/nginx/frontend_cache/*

cat << 'EOF' > /etc/nginx/sites-available/gojo_proxy
proxy_cache_path /var/cache/nginx/frontend_cache levels=1:2 keys_zone=WEB_CACHE:10m max_size=100m inactive=10m use_temp_path=off;
limit_req_zone $binary_remote_addr zone=API_LIMIT:10m rate=10r/s;

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

        proxy_cache WEB_CACHE;
        proxy_cache_valid 200 10m;
        proxy_cache_key "$scheme$request_method$host$request_uri";
        proxy_ignore_headers Cache-Control Expires Set-Cookie;
        add_header X-Cache-Status $upstream_cache_status always;
    }

    location /api {
        limit_req zone=API_LIMIT;
        limit_req_status 429;

        proxy_pass http://10.83.4.2/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

nginx -t && service nginx restart
echo "[+] Proxy Caching dan Rate Limiting pada gojo berhasil diaktifkan!"