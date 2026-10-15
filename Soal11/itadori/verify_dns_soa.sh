#!/bin/bash
# Soal 11 - Verifikasi Sinkronisasi SOA pada utahime dan shoko dari client

apk update && apk add bind-tools
echo "=== Query SOA ke DNS Master utahime (10.83.1.2) ==="
dig @10.83.1.2 jujutsu.k39.com SOA +short

echo "=== Query SOA ke DNS Slave shoko (10.83.1.3) ==="
dig @10.83.1.3 jujutsu.k39.com SOA +short