#!/bin/sh
# Soal 5 - DHCP Request pada ino
echo "[*] Requesting lease for ino..."
ip addr flush dev eth0 2>/dev/null
udhcpc -i eth0 -n -q
echo "=== IP Address ino ==="
ip -brief a show eth0
echo "=== Default Route ==="
ip route show
