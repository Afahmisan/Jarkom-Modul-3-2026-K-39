#!/bin/bash
# Soal 9 - Simulasi Gangguan Relay & Pemulihan pada Jichi

echo "=========================================="
echo "Skenario 1: Mematikan Relay (Simulasi Gangguan)"
echo "=========================================="
service isc-dhcp-relay stop
service isc-dhcp-relay status

echo ""
echo "Silakan uji permohonan IP dari klien (seharusnya timeout / gagal)."
echo "Tekan Enter untuk memulihkan relay..."
read -r

echo "=========================================="
echo "Skenario 2: Memulihkan Relay"
echo "=========================================="
service isc-dhcp-relay start
service isc-dhcp-relay status
echo "[+] Relay kembali aktif normal!"
