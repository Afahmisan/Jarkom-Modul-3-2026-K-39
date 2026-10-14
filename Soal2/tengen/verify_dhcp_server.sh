#!/bin/bash
# Soal 2 - Verifikasi status DHCP Server pada Tengen
echo "=== Status Layanan ==="
service isc-dhcp-server status
echo "=== Listening Socket UDP 67 ==="
ss -unlp | grep 67 || netstat -unlp | grep 67
