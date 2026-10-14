#!/bin/sh
# Soal 8 - Memicu Pertukaran Pesan DORA dari Klien
echo "[*] Merefresh koneksi DHCP..."
ip addr flush dev eth0 2>/dev/null
udhcpc -i eth0 -n -q -v
ip -brief a show eth0
