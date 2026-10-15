#!/bin/bash
# Soal 14 - Setup Web Frontend Worker pada panda (10.83.4.4)

echo "[*] Menginstal Nginx dan PHP-FPM pada panda..."
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update && apt-get install -y nginx php-fpm

mkdir -p /var/www/jujutsu

cat << 'EOF' > /var/www/jujutsu/index.php
<?php
echo "Jujutsu High Web Frontend - Dilayani oleh Worker: " . gethostname() . "\n";
?>
EOF

service php*-fpm start 2>/dev/null || true
PHP_SOCK=$(find /run/php/ -name "php*-fpm.sock" | head -n 1)

cat << EOF > /etc/nginx/sites-available/jujutsu
server {
    listen 80;
    server_name jujutsu.k39.com www.jujutsu.k39.com _;

    root /var/www/jujutsu;
    index index.php index.html;

    allow 10.83.1.4;
    deny all;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:${PHP_SOCK};
    }
}
EOF

ln -sf /etc/nginx/sites-available/jujutsu /etc/nginx/sites-enabled/jujutsu
rm -f /etc/nginx/sites-enabled/default

nginx -t
service php*-fpm restart
service nginx restart
echo "[+] Web Frontend Worker panda berhasil dikonfigurasi!"