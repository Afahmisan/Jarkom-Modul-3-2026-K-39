# Jarkom-Modul-3-2026-K-39

| Nama | NRP |
|---|---|
| Asfia Fahmisan | 5027251043 |
| Muhammad Atallah Mas'udi | 5027251071 |

---

## Topologi Jaringan

Pada praktikum Modul 3 ini (Curtain Protocol: Shibuya Incident), seluruh zona komunikasi Jujutsu High dihubungkan melalui sebuah router utama bernama jichi dan server DHCP utama bernama tengen:

![Topologi Shibuya Incident](images/topologi.png)

### Parameter Global:
* Prefix IP Kelompok K-39: 10.83
* Subnet Mask: /24 (255.255.255.0)
* Upstream Internet (NAT): Interface eth0 pada jichi memperoleh IP secara dinamis dari NAT (192.168.122.0/24) dengan default gateway 192.168.122.1.
* Image Docker:
  * Router & Server: ardhptr21/debinet:latest
  * Client: ardhptr21/alpinet:latest

### Tabel Alokasi IP Address Host:
| Node | Interface | IP Address | Netmask | Gateway | Peran / Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| jichi | eth0<br>eth1<br>eth2<br>eth3<br>eth4 | DHCP (NAT)<br>10.83.1.1<br>10.83.2.1<br>10.83.3.1<br>10.83.4.1 | /24<br>/24<br>/24<br>/24<br>/24 | 192.168.122.1<br>-<br>-<br>-<br>- | Router Utama & DHCP Relay<br>Gateway DMZ (Net 1)<br>Gateway Divisi A (Net 2)<br>Gateway Divisi B (Net 3)<br>Gateway Data Center (Net 4) |
| utahime | eth0 | 10.83.1.2 | /24 | 10.83.1.1 | DNS Master (Network 1 - DMZ) |
| shoko | eth0 | 10.83.1.3 | /24 | 10.83.1.1 | DNS Slave (Network 1 - DMZ) |
| gojo | eth0 | 10.83.1.4 | /24 | 10.83.1.1 | Public Reverse Proxy (Network 1 - DMZ) |
| itadori | eth0 | DHCP (10.83.2.10 sampai .35) | /24 | 10.83.2.1 | Klien Divisi A (Pool 1 - Tim Dev) |
| fushiguro | eth0 | DHCP (10.83.2.10 sampai .35) | /24 | 10.83.2.1 | Klien Divisi A (Pool 1 - Tim Dev) |
| zenin | eth0 | DHCP (10.83.2.70 sampai .95) | /24 | 10.83.2.1 | Klien Divisi A (Pool 2 - Tim Support) |
| okkotsu | eth0 | DHCP (10.83.2.70 sampai .95) | /24 | 10.83.2.1 | Klien Divisi A (Pool 2 - Tim Support) |
| ino | eth0 | DHCP (10.83.3.10 sampai .89) | /24 | 10.83.3.1 | Klien Divisi B (Short Lease 1800s) |
| kusakabe | eth0 | DHCP (10.83.3.10 sampai .89) | /24 | 10.83.3.1 | Klien Divisi B (Short Lease 1800s) |
| miwa | eth0 | DHCP (10.83.3.100 sampai .199)| /24 | 10.83.3.1 | Klien Divisi B (Long Lease 43200s) |
| kugisaki | eth0 | 10.83.3.99 (Fixed) | /24 | 10.83.3.1 | Klien Divisi B (Static Reservation) |
| tengen | eth0 | 10.83.4.10 | /24 | 10.83.4.1 | DHCP Server (Network 4 - Data Center) |
| geto | eth0 | 10.83.4.2 | /24 | 10.83.4.1 | Internal Load Balancer |
| maki | eth0 | 10.83.4.3 | /24 | 10.83.4.1 | Web Worker Frontend 1 |
| panda | eth0 | 10.83.4.4 | /24 | 10.83.4.1 | Web Worker Frontend 2 |
| nanami | eth0 | 10.83.4.5 | /24 | 10.83.4.1 | API Worker Utama 1 |
| todo | eth0 | 10.83.4.6 | /24 | 10.83.4.1 | API Worker Utama 2 |
| kirara | eth0 | 10.83.4.7 | /24 | 10.83.4.1 | API Worker Cadangan |
| yaga | eth0 | 10.83.4.8 | /24 | 10.83.4.1 | DB Master MariaDB |
| inumaki | eth0 | 10.83.4.9 | /24 | 10.83.4.1 | DB Slave MariaDB |

---

## Soal 1

Ketika Curtain menutup Shibuya, jalur komunikasi antar zona Jujutsu High terputus. Pulihkan konektivitas dasar dengan mengonfigurasi jichi: eth0 memperoleh WAN dari NAT, sedangkan eth1 sampai eth4 menjadi gateway Network 1 sampai 4 sesuai tabel pemetaan. Aktifkan IPv4 forwarding dan source NAT, lalu tetapkan IP statis host infrastruktur sesuai tabel spesifikasi. Buktikan konektivitas setiap host ke gateway dan akses eksternal dari host yang relevan.

### Konfigurasi dan Penjelasan:
Kami mengonfigurasi router jichi sebagai pusat perutean antar zona. Interface eth0 dikonfigurasi untuk menerima IP dinamis dari jaringan NAT, sedangkan eth1 sampai eth4 ditetapkan sebagai gateway masing-masing subnet: DMZ pada 10.83.1.1, Divisi A pada 10.83.2.1, Divisi B pada 10.83.3.1, dan Data Center pada 10.83.4.1. Kami mengaktifkan fitur net.ipv4.ip_forward agar kernel Linux meneruskan paket antar antarmuka, serta memasang aturan iptables MASQUERADE pada eth0 agar host jaringan lokal dapat mengakses jaringan internet luar.

Seluruh server infrastruktur pada DMZ dan Data Center kami pasang IP statis dengan subnet mask 255.255.255.0 dan default gateway yang mengarah ke interface jichi pada segmen masing-masing.

### Bukti Verifikasi:
Pemeriksaan antarmuka, aturan NAT, dan pengujian ping internet pada jichi:

![Bukti Soal 1 - Jichi Router dan NAT](images/soal1_jichi.png)

Pemeriksaan IP statis dan tes konektivitas dari server tengen menuju gateway 10.83.4.1 serta internet:

![Bukti Soal 1 - Tengen Static Host](images/soal1_tengen.png)

---

## Soal 2

Tengen, penjaga pusat distribusi di Data Center, harus mengambil alih pengalokasian alamat bagi wilayah yang membutuhkan konfigurasi dinamis. Konfigurasikan isc-dhcp-server pada 10.83.4.10. Deklarasikan Network 4 (10.83.4.0/24) sebagai subnet lokal tanpa pool dinamis, lalu siapkan scope DHCP untuk Network 2 (10.83.2.0/24) dan Network 3 (10.83.3.0/24). Validasi konfigurasi dan pastikan service aktif tanpa error "No subnet declaration".

### Konfigurasi dan Penjelasan:
Kami memasang paket isc-dhcp-server pada node tengen (10.83.4.10) dan menetapkan interface eth0 sebagai antarmuka layanan.

Pada file /etc/dhcp/dhcpd.conf, kami mendeklarasikan subnet 10.83.4.0/24 tanpa baris range alokasi. Deklarasi kosong ini diperlukan karena daemon DHCP mewajibkan deklarasi subnet lokal pada antarmuka yang didengarkannya. Tanpa deklarasi tersebut, daemon akan berhenti dengan galat "No subnet declaration for eth0". Scope subnet untuk Network 2 dan Network 3 juga kami siapkan agar server siap melayani permintaan sewa dari divisi lain.

### Bukti Verifikasi:
Hasil pengujian status layanan dan pengecekan socket UDP port 67 pada tengen:

![Bukti Soal 2 - Tengen DHCP Server](images/soal2_tengen.png)

---

## Soal 3

Permintaan alamat dari Divisi A dan Divisi B tidak dapat menyeberangi subnet secara langsung. Konfigurasikan jichi sebagai DHCP Relay menuju tengen (10.83.4.10), menggunakan eth2 untuk Network 2 dan eth3 untuk Network 3. Buktikan bahwa client dari kedua subnet berhasil memperoleh lease melalui relay.

### Konfigurasi dan Penjelasan:
Karena router secara default tidak meneruskan paket siaran (broadcast) lintas subnet, kami mengonfigurasi isc-dhcp-relay pada router jichi. Relay diarahkan ke server tengen (10.83.4.10) dengan mendengarkan interface eth1, eth2, eth3, dan eth4.

Saat klien di Divisi A atau Divisi B mengirimkan siaran DHCP Discover, jichi menangkap paket tersebut, mengisi alamat gateway interface penerima pada field giaddr (10.83.2.1 atau 10.83.3.1), lalu meneruskannya secara unicast ke tengen.

### Bukti Verifikasi:
Status proses dan verifikasi port UDP 67 untuk layanan relay pada jichi:

![Bukti Soal 3 - Jichi DHCP Relay](images/soal3_jichi.png)

---

## Soal 4

Agar tim Dev dan Support di Divisi A menerima jatah alamat yang berbeda, atur dua pool DHCP pada Network 2. Tetapkan Pool 1 (10.83.2.10 sampai 10.83.2.35) untuk itadori dan fushiguro, serta Pool 2 (10.83.2.70 sampai 10.83.2.95) untuk zenin dan okkotsu. Rentang 10.83.2.36 sampai 10.83.2.69 tidak boleh dialokasikan. Karena seluruh client berada pada subnet yang sama, gunakan DHCP class berdasarkan MAC Address atau Client ID untuk memisahkan kedua kelompok.

### Konfigurasi dan Penjelasan:
Untuk membagi klien di subnet yang sama ke dalam rentang alamat yang berbeda, kami membuat dua class pada konfigurasi DHCP: dev-pool1 dan support-pool2. Masing-masing klien didaftarkan melalui baris subclass menggunakan MAC address fisiknya.

Pool 1 dibatasi untuk anggota dev-pool1 dengan rentang 10.83.2.10 sampai 10.83.2.35. Pool 2 dibatasi untuk anggota support-pool2 dengan rentang 10.83.2.70 sampai 10.83.2.95. Rentang 10.83.2.36 sampai 10.83.2.69 sengaja tidak dideklarasikan pada pool mana pun agar tidak teralokasi dan terisolasi dengan aman.

### Bukti Verifikasi:
Bukti perolehan IP klien Tim Dev pada Pool 1:

![Bukti Soal 4 - Itadori](images/soal4_itadori.png)

![Bukti Soal 4 - Fushiguro](images/soal4_fushiguro.png)

Bukti perolehan IP klien Tim Support pada Pool 2:

![Bukti Soal 4 - Zenin](images/soal4_zenin.png)

![Bukti Soal 4 - Okkotsu](images/soal4_okkotsu.png)

---

## Soal 5

Setiap tim lapangan memiliki durasi operasi yang berbeda. Pada Network 3, berikan short lease 30 menit (1800 detik) kepada ino dan kusakabe, serta long lease 12 jam (43200 detik) kepada miwa. Gunakan pool short lease 10.83.3.10 sampai 10.83.3.89 dan pool long lease 10.83.3.100 sampai 10.83.3.199. Sesuaikan default-lease-time dan max-lease-time untuk setiap kelas client. Berikan pula DHCP options berupa DNS 10.83.1.2 dan 10.83.1.3, serta domain-search k39.com.

### Konfigurasi dan Penjelasan:
Kami membedakan durasi masa sewa pada Network 3 menggunakan dua class: short-lease dan long-lease.

Pool short-lease dialokasikan untuk ino dan kusakabe pada rentang 10.83.3.10 sampai 10.83.3.89 dengan masa sewa 1800 detik (30 menit). Pool long-lease dialokasikan untuk miwa pada rentang 10.83.3.100 sampai 10.83.3.199 dengan masa sewa 43200 detik (12 jam).

Kami juga menambahkan opsi jaringan global pada subnet berupa router gateway 10.83.3.1, DNS resolver 10.83.1.2 dan 10.83.1.3, serta domain pencarian k39.com yang otomatis diterapkan pada file /etc/resolv.conf klien.

### Bukti Verifikasi:
Penerapan konfigurasi baru pada tengen:

![Bukti Soal 5 - Update Config Tengen](images/soal5_tengen.png)

Hasil permohonan sewa ino dengan masa sewa 1800 detik:

![Bukti Soal 5 - Ino Short Lease](images/soal5_ino.png)

Hasil permohonan sewa kusakabe dengan masa sewa 1800 detik:

![Bukti Soal 5 - Kusakabe Short Lease](images/soal5_kusakabe.png)

Hasil permohonan sewa miwa dengan masa sewa 43200 detik dan verifikasi file resolv.conf:

![Bukti Soal 5 - Miwa Long Lease dan DNS](images/soal5_miwa.png)

---

## Soal 6

Kugisaki ditetapkan sebagai personel VIP yang harus mempertahankan alamat yang sama setiap kali terhubung. Buat DHCP static lease berdasarkan MAC Address client tersebut dengan fixed address 10.83.3.99. Pastikan alamat ini berada di luar seluruh pool dinamis, validasi konfigurasi server, lalu renew lease pada client. Buktikan bahwa alamat yang diterima sesuai dengan reservasi.

### Konfigurasi dan Penjelasan:
Kami membuat reservasi IP statis melalui blok deklarasi host kugisaki pada konfigurasi DHCP server. MAC address ethernet milik kugisaki (02:42:c1:a8:92:00) dipetakan secara permanen ke alamat 10.83.3.99.

Alamat 10.83.3.99 berada di luar batas pool sewa dinamis Divisi B (antara batas atas pool pendek .89 dan batas bawah pool panjang .100), sehingga memenuhi syarat untuk tidak bersinggungan dengan pool dinamis klien lain.

### Bukti Verifikasi:
Hasil permohonan sewa pada kugisaki yang menerima tepat alamat 10.83.3.99 dengan gateway 10.83.3.1:

![Bukti Soal 6 - Fixed Address Kugisaki](images/soal6_kugisaki.png)

---

## Soal 7

Setelah aturan alokasi diterapkan, pastikan setiap client menerima konfigurasi jaringan sesuai wilayahnya: subnet mask 255.255.255.0 (/24), gateway dan broadcast address yang benar, DNS 10.83.1.2 serta 10.83.1.3, dan domain-search yang ditentukan. Periksa IP address dan routing seluruh client Divisi A dan Divisi B, kemudian cocokkan lease dengan /var/lib/dhcp/dhcpd.leases pada tengen. Pastikan tidak ada alamat yang bertabrakan atau berada di luar kebijakan pool.

### Konfigurasi dan Penjelasan:
Kami memeriksa catatan basis data sewa aktif pada file /var/lib/dhcp/dhcpd.leases di tengen. Setiap entri sewa diverifikasi untuk memastikan alamat IP, MAC address, serta waktu awal dan akhir sewa tercatat sesuai dengan pembagian pool yang telah ditentukan, tanpa adanya tabrakan alamat antar host.

### Bukti Verifikasi:
Tampilan audit database sewa aktif pada server tengen:

![Bukti Soal 7 - Audit Database Leases](images/soal7_tengen.png)

---

## Soal 8

Sebelum Curtain dibuka kembali, buktikan bahwa proses pemberian alamat berjalan sesuai protokol. Lakukan packet capture saat salah satu client Network 2 atau Network 3 meminta lease baru. Gunakan tcpdump pada tengen atau jalur menuju Data Center untuk menunjukkan urutan DHCPDISCOVER -> DHCPOFFER -> DHCPREQUEST -> DHCPACK. Identifikasi alamat server, alamat yang diberikan, lease time, dan field giaddr. Pastikan nilai giaddr sesuai dengan interface jichi yang menerima request dari subnet client.

### Konfigurasi dan Penjelasan:
Kami melakukan penangkapan paket menggunakan Wireshark pada antarmuka jalur menuju tengen (port UDP 67/68) saat klien itadori mengajukan permintaan alamat IP baru.

Empat tahapan jabat tangan DORA tertangkap secara runtut:
1. DHCP Discover: jichi meneruskan siaran klien dengan menyematkan alamat relay giaddr 10.83.2.1.
2. DHCP Offer: tengen menawarkan alamat IP 10.83.2.10 kembali ke alamat relay 10.83.2.1.
3. DHCP Request: klien itadori mengajukan konfirmasi pemilihan alamat yang ditawarkan.
4. DHCP ACK: server tengen meresmikan peminjaman alamat sewa kepada klien.

### Bukti Verifikasi:
Hasil tangkapan paket Wireshark yang memperlihatkan urutan DHCP Discover, Offer, Request, dan ACK:

![Bukti Soal 8 - DORA Packet Capture Wireshark](images/soal8_wireshark.png)

---

## Soal 9

Sebuah gangguan memutus jalur relay dan membuat permintaan alamat tidak sampai ke Data Center. Hentikan service DHCP Relay pada jichi, lalu paksa salah satu client di Network 2 atau Network 3 meminta lease baru dan catat gejalanya. Pulihkan service relay, ulangi permintaan DHCP, lalu buktikan bahwa client kembali memperoleh alamat dari pool yang benar dengan gateway semula.

### Konfigurasi dan Penjelasan:
Untuk menguji toleransi gangguan, kami menghentikan layanan isc-dhcp-relay pada router jichi. Saat itadori mencoba memperbarui alamat IP, klien mengalami batas waktu habis (timeout) karena paket broadcast tidak dapat diteruskan ke Data Center tanpa adanya proses relay.

Setelah layanan relay diaktifkan kembali pada jichi, klien itadori langsung berhasil mendapatkan kembali alamat IP 10.83.2.10 dari Pool 1 dengan gateway default 10.83.2.1.

### Bukti Verifikasi:
Pengujian saat relay dihentikan dan klien mengalami kegagalan sewa:

![Bukti Soal 9 - Simulasi Gangguan Relay](images/soal9_gangguan.png)

Pengujian saat relay dipulihkan dan klien kembali menerima alamat dengan normal:

![Bukti Soal 9 - Pemulihan Layanan Relay](images/soal9_pulih.png)

---

## Soal 10

Setelah gangguan Shibuya tertangani, pastikan pemulihan bertahan setelah restart. Aktifkan autostart DHCP Server pada tengen dan DHCP Relay pada jichi, lalu restart kedua node. Verifikasi status layanan, IP, gateway, lease, dan konektivitas client Network 2 sampai 3. Pastikan kebijakan Pool 1, Pool 2, short lease, long lease, dan fixed address tetap berlaku.

### Konfigurasi dan Penjelasan:
Pada lingkungan container debinet GNS3, konfigurasi yang berjalan di memori perlu dipulihkan secara otomatis saat sistem menyala ulang. Kami menyiapkan skrip /root/init.sh pada jichi dan tengen yang otomatis dijalankan saat booting.

Pada jichi, skrip ini mengembalikan konfigurasi seluruh antarmuka eth0 sampai eth4, aturan iptables NAT, forwarding IPv4, serta menjalankan ulang layanan isc-dhcp-relay.

Pada tengen, skrip memulihkan alamat IP statis 10.83.4.10, file konfigurasi /etc/dhcp/dhcpd.conf, dan menjalankan ulang layanan isc-dhcp-server.

### Bukti Verifikasi:
Verifikasi status layanan dan konfigurasi antarmuka pada tengen dan jichi setelah kedua node di-restart:

![Bukti Soal 10 - Verifikasi Autostart Setelah Reboot](images/soal10_autostart.png)
