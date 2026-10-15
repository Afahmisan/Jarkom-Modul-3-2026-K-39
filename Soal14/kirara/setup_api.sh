#!/bin/bash
# Soal 14, 17, 18 - Setup API Worker Backup pada kirara (10.83.4.7)

echo "[*] Menginstal Nginx, PHP-FPM, dan PHP-MySQL pada kirara..."
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update && apt-get install -y nginx php-fpm php-mysql mariadb-client

mkdir -p /var/www/api

cat << 'EOF' > /var/www/api/index.php
<?php
header('Content-Type: application/json');

$db_host = '10.83.4.8';
$db_user = 'jujutsu_app';
$db_pass = 'jujutsu123';$db_name = 'db_shibuya_k39';

$worker = gethostname();$client_ip = $_SERVER['HTTP_X_REAL_IP'] ?? $_SERVER['REMOTE_ADDR'];

$conn = new mysqli($db_host,$db_user, $db_pass,$db_name);
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "worker" => $worker,
        "message" => "Koneksi DB Gagal: " . $conn->connect_error
    ]) . "\n";
    exit;
}

$stmt =$conn->prepare("INSERT INTO request_logs (worker_name, client_ip) VALUES (?, ?)");
$stmt->bind_param("ss", $worker, $client_ip);$stmt->execute();
$stmt->close();$conn->close();

echo json_encode([
    "status" => "success",
    "worker" => $worker,
    "client_ip" => $client_ip,
    "timestamp" => date('Y-m-d H:i:s')
]) . "\n";
?>
EOF

service php*-fpm start 2>/dev/null || true
PHP_SOCK=$(find /run/php/ -name "php*-fpm.sock" | head -n 1)

cat << EOF > /etc/nginx/sites-available/api
server {
    listen 80;
    server_name jujutsu.k39.com www.jujutsu.k39.com _;

    root /var/www/api;
    index index.php;

    allow 10.83.4.2;
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

ln -sf /etc/nginx/sites-available/api /etc/nginx/sites-enabled/api
rm -f /etc/nginx/sites-enabled/default

nginx -t
service php*-fpm restart
service nginx restart
echo "[+] API Worker Backup kirara berhasil dikonfigurasi!"