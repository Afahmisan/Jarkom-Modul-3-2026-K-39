#!/bin/bash
# Soal 7 - Audit Database Lease Tengen

echo "=== Total Lease Tercatat ==="
grep -c "^lease " /var/lib/dhcp/dhcpd.leases 2>/dev/null || echo "0"

echo ""
echo "=== Detail Lease Aktif ==="
awk '
/^lease / { ip = $2 }
/hardware ethernet/ { mac = $3; sub(/;/, "", mac) }
/client-hostname/ { host = $2; gsub(/[";]/, "", host) }
/starts/ { start = $3 " " $4; sub(/;/, "", start) }
/ends/ { end = $3 " " $4; sub(/;/, "", end) }
/^}/ {
    printf "IP: %-15s | MAC: %-18s | Host: %-10s | Ends: %s\n", ip, mac, host, end
    ip=""; mac=""; host="-"; end=""
}
' /var/lib/dhcp/dhcpd.leases | sort -u
