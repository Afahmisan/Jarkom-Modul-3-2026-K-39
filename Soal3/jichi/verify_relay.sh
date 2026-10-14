#!/bin/bash
# Soal 3 - Verifikasi DHCP Relay pada Jichi
echo "=== Status Layanan Relay ==="
service isc-dhcp-relay status
echo "=== Socket Relay UDP 67 ==="
ss -unlp | grep 67 || netstat -unlp | grep 67
