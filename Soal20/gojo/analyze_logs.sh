#!/bin/bash
# Soal 20 - Analisis Access Log & Error Log pada gojo

echo "=== RINGKASAN HTTP STATUS CODE DI ACCESS.LOG GOJO ==="
awk '{print $9}' /var/log/nginx/access.log | sort | uniq -c | sort -nr

echo ""
echo "=== BUKTI PENOLAKAN RATE LIMIT DI ERROR.LOG GOJO (5 TERAKHIR) ==="
grep "limiting requests" /var/log/nginx/error.log | tail -n 5