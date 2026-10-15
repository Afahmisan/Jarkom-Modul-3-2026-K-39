#!/bin/bash
# Soal 15 - Verifikasi Distribusi Beban 3:1 pada geto

echo "=== Mengirim 8 Request ke geto (10.83.4.2) ==="
for i in {1..8}; do
    curl -s http://10.83.4.2
done