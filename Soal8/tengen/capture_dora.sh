#!/bin/bash
# Soal 8 - Capture Paket DORA di Tengen
echo "[*] Memulai tcpdump untuk DORA (port 67 / 68)..."
tcpdump -i eth0 -n -vvv "udp port 67 or udp port 68"
