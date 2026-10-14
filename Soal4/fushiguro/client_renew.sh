#!/bin/sh
# Soal 4 - DHCP Request pada fushiguro
echo "[*] Requesting lease for fushiguro..."
ip addr flush dev eth0 2>/dev/null
udhcpc -i eth0 -n -q
echo "=== IP Address fushiguro ==="
ip -brief a show eth0
echo "=== Default Route ==="
ip route show
