#!/bin/sh
# Soal 9 - Uji Permohonan Klien saat Relay Terganggu
echo "[*] Mencoba permohonan DHCP (timeout 5 detik)..."
ip addr flush dev eth0 2>/dev/null
udhcpc -i eth0 -n -q -T 2 -t 2
if [ $? -ne 0 ]; then
    echo "[-] GAGAL memperoleh IP (Relay terputus / gangguan aktif)"
else
    echo "[+] Berhasil memperoleh IP"
    ip -brief a show eth0
fi
