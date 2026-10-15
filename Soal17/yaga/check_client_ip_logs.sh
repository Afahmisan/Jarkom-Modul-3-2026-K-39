#!/bin/bash
# Soal 17 - Pemeriksaan Log IP Klien Asli pada Database yaga

mysql -u root -D db_shibuya_k39 -e "SELECT * FROM request_logs ORDER BY id DESC LIMIT 10;"