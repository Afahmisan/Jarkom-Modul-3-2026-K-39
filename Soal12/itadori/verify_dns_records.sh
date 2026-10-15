#!/bin/bash
# Soal 12 - Pengujian A, CNAME, PTR, dan Forwarder dari client

apk update && apk add bind-tools
echo "=== 1. Cek A Record jujutsu.k39.com ==="
dig jujutsu.k39.com +short

echo "=== 2. Cek CNAME www.jujutsu.k39.com ==="
dig www.jujutsu.k39.com

echo "=== 3. Cek Reverse DNS (PTR) 10.83.1.4 ==="
dig -x 10.83.1.4

echo "=== 4. Cek Forwarder Internet (ping google.com) ==="
ping -c 3 google.com