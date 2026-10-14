#!/bin/sh
# Soal 5 - DHCP Request pada kusakabe
echo "[*] Requesting lease for kusakabe..."
ip addr flush dev eth0 2>/dev/null
udhcpc -i eth0 -n -q
echo "=== IP Address kusakabe ==="
ip -brief a show eth0
echo "=== Default Route ==="
ip route show
