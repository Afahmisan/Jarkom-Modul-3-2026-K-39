#!/bin/sh
# Soal 4 - DHCP Request pada itadori
echo "[*] Requesting lease for itadori..."
ip addr flush dev eth0 2>/dev/null
udhcpc -i eth0 -n -q
echo "=== IP Address itadori ==="
ip -brief a show eth0
echo "=== Default Route ==="
ip route show
