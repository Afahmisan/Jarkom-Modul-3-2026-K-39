#!/bin/sh
# Soal 4 - DHCP Request pada okkotsu
echo "[*] Requesting lease for okkotsu..."
ip addr flush dev eth0 2>/dev/null
udhcpc -i eth0 -n -q
echo "=== IP Address okkotsu ==="
ip -brief a show eth0
echo "=== Default Route ==="
ip route show
