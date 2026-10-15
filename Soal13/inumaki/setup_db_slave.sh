#!/bin/bash
# Soal 13 - Setup MariaDB Slave pada inumaki (10.83.4.9)

echo "[*] Menginstal dan mengonfigurasi MariaDB Slave di inumaki..."
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
server-id               = 2
relay-log               = /var/log/mysql/mysql-relay-bin.log
log_bin                 = /var/log/mysql/mysql-bin.log
binlog_do_db            = db_shibuya_k39
read_only               = 1
EOF

service mariadb restart 2>/dev/null || service mysql restart

echo "Masukkan nama File binlog dari yaga (contoh: mysql-bin.000001):"
read -r LOG_FILE
echo "Masukkan angka Position dari yaga (contoh: 328):"
read -r LOG_POS

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS db_shibuya_k39;
USE db_shibuya_k39;

CREATE TABLE IF NOT EXISTS request_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    worker_name VARCHAR(50),
    client_ip VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

STOP SLAVE;
CHANGE MASTER TO
    MASTER_HOST='10.83.4.8',
    MASTER_USER='repl_user',
    MASTER_PASSWORD='jujutsu123',
    MASTER_LOG_FILE='${LOG_FILE}',
    MASTER_LOG_POS=${LOG_POS};
START SLAVE;
EOF

echo "[+] Status Replikasi Slave pada inumaki:"
mysql -u root -e "SHOW SLAVE STATUS\G" | grep -E "Slave_IO_Running|Slave_SQL_Running|Last_Error"