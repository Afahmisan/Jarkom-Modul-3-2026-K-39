#!/bin/bash
# Soal 13 - Setup MariaDB Master pada yaga (10.83.4.8)

echo "[*] Menginstal dan mengonfigurasi MariaDB Master di yaga..."
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update && apt-get install -y mariadb-server mariadb-client

cat << 'EOF' > /etc/mysql/mariadb.conf.d/50-server.cnf
[mysqld]
user                    = mysql
pid-file                = /run/mysqld/mysqld.pid
socket                  = /run/mysqld/mysqld.sock
port                    = 3306
basedir                 = /usr
datadir                 = /var/lib/mysql
tmpdir                  = /tmp
lc-messages-dir         = /usr/share/mysql
bind-address            = 0.0.0.0
server-id               = 1
log_bin                 = /var/log/mysql/mysql-bin.log
binlog_do_db            = db_shibuya_k39
EOF

service mariadb restart 2>/dev/null || service mysql restart

mysql -u root << 'EOF'
CREATE DATABASE IF NOT EXISTS db_shibuya_k39;
USE db_shibuya_k39;

CREATE TABLE IF NOT EXISTS request_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    worker_name VARCHAR(50),
    client_ip VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE USER IF NOT EXISTS 'repl_user'@'%' IDENTIFIED BY 'jujutsu123';
GRANT REPLICATION SLAVE ON *.* TO 'repl_user'@'%';

CREATE USER IF NOT EXISTS 'jujutsu_app'@'10.83.4.%' IDENTIFIED BY 'jujutsu123';
GRANT ALL PRIVILEGES ON db_shibuya_k39.* TO 'jujutsu_app'@'10.83.4.%';

FLUSH PRIVILEGES;
EOF

echo "[+] MariaDB Master yaga berhasil dikonfigurasi!"
mysql -u root -e "SHOW MASTER STATUS\G"