#!/bin/sh
# Soal 6 - Verifikasi IP Fixed Kugisaki
echo "[*] Requesting fixed lease for kugisaki..."
ip addr flush dev eth0 2>/dev/null
udhcpc -i eth0 -n -q
echo "=== IP Address Kugisaki ==="
ip -brief a show eth0
echo "=== Route Kugisaki ==="
ip route show
