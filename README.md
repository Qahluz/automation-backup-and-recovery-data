# Sistem Otomasi Backup dan Pemulihan Data Linux

Proyek Akhir Mata Kuliah Sistem Operasi
S1 Sistem Informasi – UPN Veteran Jakarta

## 1. Deskripsi Proyek

Proyek ini mengembangkan sistem otomasi pencadangan dan pemulihan data pada Linux menggunakan Shell Script.

Sistem dirancang untuk memvalidasi direktori sumber dan tujuan, membuat arsip backup dengan identitas waktu, memeriksa integritas arsip menggunakan checksum SHA-256, serta memulihkan data ke direktori pengujian.

Sistem juga dilengkapi mekanisme penguncian proses (file locking), pencatatan aktivitas melalui log, pembuatan laporan backup, pembatasan hak akses terhadap arsip, serta monitoring penggunaan CPU dan memori. Integrasi Docker digunakan untuk menguji pembacaan laporan melalui bind mount read-only.

## 2. Fitur Utama

1. Validasi sumber, tujuan, dan parameter backup.
2. Pembuatan arsip backup dengan identitas waktu.
3. Verifikasi integritas arsip menggunakan SHA-256.
4. Pemulihan data ke direktori pengujian.
5. Pencegahan proses backup bersamaan menggunakan `flock`.
6. Pencatatan aktivitas dan penanganan kesalahan melalui log.
7. Pembuatan laporan hasil backup.
8. Pembatasan akses terhadap arsip backup melalui permission Linux.
9. Monitoring proses serta penggunaan CPU dan memori.
10. Pengujian Docker menggunakan bind mount read-only untuk membaca laporan.

## 3. Struktur Repository

- `config/`: contoh dan dokumentasi konfigurasi.
- `scripts/`: Shell Script untuk setiap modul sistem.
- `tests/`: skenario pengujian, data uji, dan dokumentasi pengujian setiap anggota.
- `docs/`: rancangan proyek, pembagian kontribusi, dan analisis teknis.
- `evidence/`: bukti implementasi dan hasil pengujian.
- `output/`: laporan dan hasil keluaran backup.
- `logs/`: catatan aktivitas sistem.

## 4. Lingkungan Pengujian

Pengujian utama dilaksanakan menggunakan mesin virtual Ubuntu Server.

Komponen yang digunakan:

- Sistem operasi: Ubuntu Server.
- Shell: Bash.
- Pengelolaan arsip: GNU Tar dan gzip.
- Verifikasi integritas: `sha256sum`.
- Penguncian proses: `flock`.
- Monitoring: utilitas Linux untuk pemantauan proses dan sumber daya sistem.
- Container: Docker.

Informasi versi sistem operasi, perangkat lunak, dan spesifikasi mesin virtual dicatat pada:

[`evidence/07-ubuntu-server-demo/00-environment/system-info.txt`](evidence/07-ubuntu-server-demo/00-environment/system-info.txt)

## 5. Identitas dan Pembagian Tugas Anggota

Kelompok terdiri atas enam anggota dan telah memperoleh persetujuan dosen pengampu.

| No. | NIM | Nama Lengkap | Tanggung Jawab |
|---|---|---|---|
| 1 | 2510512175 | Muhammad Afaf Kafabillah | Verifikasi integritas arsip dan checksum SHA-256. |
| 2 | 2510512178 | Muhammad Nur Ihsani Izzul Haq Rosyid | Pengelolaan lock, log, laporan backup, dan integrasi Docker. |
| 3 | 2510512181 | Muhammad Agung Budi Laksono | Pembuatan arsip backup, pengaturan permission, dan pengujian akses arsip. |
| 4 | 2510512188 | Panggi Hidayah | Pemulihan data dan pemeriksaan kesesuaian hasil restore. |
| 5 | 2510512195 | Muhamad Afwan Imam Nasuha | Validasi sumber, direktori tujuan, parameter, dan hak akses direktori, serta pemeliharaan repository GitHub, penataan struktur direktori dan berkas, serta pengelolaan dokumentasi proyek. |
| 6 | 2510512202 | Muhammad Rafif Husein Salam | Monitoring proses backup, penggunaan CPU dan memori, serta membantu pengujian hak akses arsip. |

Rincian kontribusi dan pembagian pekerjaan masing-masing anggota tersedia pada [`docs/contribution-map.md`](docs/contribution-map.md).

## 6. Matriks Skenario dan Hasil Pengujian

Pengujian dilakukan melalui skenario positif dan negatif. Skenario positif digunakan untuk memastikan fitur berjalan sesuai fungsinya, sedangkan skenario negatif digunakan untuk memastikan sistem menolak kondisi atau input yang tidak sesuai.

Seluruh bukti pengujian T01–T18 disimpan di direktori induk [`evidence/07-ubuntu-server-demo/`](evidence/07-ubuntu-server-demo/). Nama direktori pada kolom Bukti merupakan subdirektori dari direktori tersebut.

| ID | Penanggung Jawab | Positif | Negatif | Hasil Aktual | Status | Bukti |
|---|---|---|---|---|---|---|
| T01 | Afwan (2510512195) | Validasi sumber dan tujuan yang tersedia berhasil. | - | Validasi berhasil, exit 0. | Lulus | `01-validation/` |
| T02 | Afwan (2510512195) | - | Sumber tidak ditemukan atau berupa file ditolak. | Kedua kondisi ditolak, exit 3. | Lulus | `01-validation/` |
| T03 | Afwan (2510512195) | - | Pemanggilan validasi tanpa parameter lengkap ditolak. | Parameter tidak lengkap ditolak, exit 2. | Lulus | `01-validation/` |
| T04 | Agung (2510512181) | Arsip backup berhasil dibuat dan checksum diverifikasi. | - | Arsip berhasil dibuat dengan permission 600, exit 0. | Lulus | `02-backup/` |
| T05 | Agung (2510512181) | - | Backup ditolak ketika direktori tujuan tidak dapat ditulis. | Validasi menolak direktori tujuan, exit 6. | Lulus | `02-backup/` |
| T06 | Afaf (2510512175) | Checksum arsip asli berhasil diverifikasi. | - | Checksum cocok, exit 0. | Lulus | `03-checksum/` |
| T07 | Afaf (2510512175) | - | Arsip yang telah dimodifikasi harus terdeteksi. | Checksum tidak cocok dan arsip dinyatakan berubah, exit 1. | Lulus | `03-checksum/` |
| T08 | Panggi (2510512188) | Arsip valid berhasil dipulihkan dan hasilnya dibandingkan dengan sumber. | - | Restore berhasil, exit 0. Hasil diff identik, exit 0. | Lulus | `04-restore/` |
| T09 | Panggi (2510512188) | - | Arsip rusak ditolak dan tidak boleh mengekstrak data. | Restore ditolak, exit 1. Direktori tujuan tetap kosong, pemeriksaan exit 0. | Lulus | `04-restore/` |
| T10 | Izzul (2510512178) | Proses backup pertama berhasil memperoleh lock dan berjalan. | Proses backup kedua ditolak saat lock sedang digunakan. | Proses pertama berhasil, exit 0. Proses kedua ditolak karena lock aktif. | Lulus | `06-lock-log-report/` |
| T11 | Izzul (2510512178) | Aktivitas backup dapat diperiksa melalui file log. | - | File `output/backup.log` ditemukan dan berisi catatan aktivitas backup, validasi, checksum, serta status proses. | Lulus | `06-lock-log-report/` |
| T12 | Izzul (2510512178) | Laporan backup berhasil dibuat dan informasi checksum sesuai dengan arsip. | - | Laporan tersedia dan checksum arsip cocok dengan nilai yang diperiksa. | Lulus | `06-lock-log-report/` |
| T13 | Izzul (2510512178) | Container Docker berhasil membaca `laporan.txt` melalui bind mount read-only. | - | Laporan berhasil dibaca dari container, exit 0. | Lulus | `08-docker/` |
| T14 | Izzul (2510512178) | - | Container mencoba menambahkan isi pada laporan melalui mount read-only. | Operasi append ditolak dengan pesan `Read-only file system`, exit 1. Checksum laporan tidak berubah. | Lulus | `08-docker/` |
| T15 | Rafif (2510512202) | Sistem berhasil memonitor proses backup yang sedang berjalan. | - | Monitoring mencatat 18 sampel proses. Backup dan monitoring masing-masing exit 0. | Lulus | `06-monitoring/` |
| T16 | Rafif (2510512202) | - | Monitoring menggunakan PID yang tidak valid harus ditolak. | PID ditolak, exit 1. Log mencatat `STATUS=REJECTED` tanpa metrik proses palsu. | Lulus | `06-monitoring/` |
| T17 | Agung (2510512181), dibantu Rafif | Pemilik arsip yang berwenang berhasil membaca isi arsip. | - | Akun `agung` berhasil membaca arsip berizin 600, exit 0. | Lulus | `05-access-control/` |
| T18 | Agung (2510512181), dibantu Rafif | - | Akun yang tidak berwenang ditolak ketika mencoba membaca arsip. | Akun `penguji` mendapatkan `Permission denied`, exit 2. | Lulus | `05-access-control/` |

### Catatan Hasil Pengujian

1. Seluruh skenario T01–T18 telah dilaksanakan pada VM Ubuntu Server kelompok.
2. Pengujian negatif dinyatakan lulus apabila sistem memberikan penolakan sesuai kondisi yang diharapkan.
3. Arsip backup menggunakan permission 600 untuk membatasi pembacaan hanya kepada pemiliknya.
4. Pada T10, proses backup kedua ditolak ketika proses pertama masih memegang lock.
5. Pada T14, Docker tidak dapat mengubah laporan yang dipasang melalui bind mount read-only.
6. Pada T15, monitoring mengamati proses backup yang benar-benar aktif, bukan proses simulasi terpisah.
7. Pada T16, PID tidak valid ditolak dan dicatat sebagai `STATUS=REJECTED`.
8. Pengujian tambahan yang tidak termasuk matriks resmi T01–T18 disimpan secara terpisah pada `evidence/07-ubuntu-server-demo/99-pengujian-tambahan/`.

## 7. Dokumentasi dan Evidence

Hasil pengujian disimpan dalam direktori:

`evidence/07-ubuntu-server-demo/`

Susunan evidence:

| Direktori | Isi |
|---|---|
| `01-validation/` | Bukti T01–T03 |
| `02-backup/` | Bukti T04–T05 |
| `03-checksum/` | Bukti T06–T07 |
| `04-restore/` | Bukti T08–T09 |
| `05-access-control/` | Bukti T17–T18 |
| `06-lock-log-report/` | Bukti T10–T12 |
| `06-monitoring/` | Bukti T15–T16 |
| `08-docker/` | Bukti T13–T14 |
| `99-pengujian-tambahan/` | Bukti pengujian tambahan di luar matriks utama |

Indeks nama screenshot dan keterangan setiap bukti tersedia pada [`evidence/07-ubuntu-server-demo/README-SCREENSHOT-INDEX.md`](evidence/07-ubuntu-server-demo/README-SCREENSHOT-INDEX.md).

Evidence mencakup screenshot terminal dan hasil pengujian berbentuk teks untuk mendukung pemeriksaan ulang.

## 8. Status Pengerjaan

Implementasi sistem otomasi backup dan pemulihan data Linux telah diselesaikan dan diuji pada VM Ubuntu Server kelompok.

Seluruh skenario utama T01–T18 telah dilaksanakan, mencakup validasi, pembuatan arsip, verifikasi checksum, pemulihan data, penguncian proses, pencatatan log, pembuatan laporan, pembatasan hak akses, monitoring, dan aktivitas Docker read-only.

Hasil aktual setiap pengujian dan bukti pelaksanaannya telah didokumentasikan dalam repository.

## 9. Kesimpulan

Sistem otomasi backup dan pemulihan data Linux berhasil menjalankan fungsi utama sesuai skenario pengujian yang telah ditetapkan. Pengujian positif menunjukkan fitur dapat berjalan sesuai tujuan, sedangkan pengujian negatif menunjukkan sistem mampu menolak input, arsip, proses, dan akses yang tidak sesuai.

Dokumentasi kontribusi anggota, hasil pengujian, serta evidence disertakan untuk mendukung evaluasi proyek dan keterlacakan pekerjaan setiap anggota kelompok.


## 10. Panduan Instalasi dan Penggunaan

### 10.1 Persiapan Lingkungan

Sistem dijalankan pada Linux dengan Bash dan utilitas pendukung berikut:

- GNU Coreutils, termasuk `realpath` dan `sha256sum`.
- GNU Tar dan gzip untuk pengelolaan arsip.
- Util-linux untuk mekanisme `flock`.
- Procps untuk pemantauan proses.
- Findutils untuk pencarian berkas.

Pada Ubuntu Server, dependensi dapat dipasang menggunakan:

```bash
sudo apt update
sudo apt install -y bash coreutils findutils tar gzip util-linux procps
```

Verifikasi ketersediaan utilitas:

```bash
command -v bash realpath tar gzip sha256sum flock ps
```

Pastikan terminal berada pada direktori utama repository sebelum menjalankan script.

### 10.2 Konfigurasi Lingkungan Pengujian

Sebelum menjalankan sistem, muat konfigurasi lingkungan demonstrasi yang telah disediakan pada repository.

```bash
cd ~/automation-backup-and-recovery-data

source tests/demo/demo-env.sh
```

Script konfigurasi tersebut menetapkan beberapa variabel lingkungan:

| Variabel | Fungsi |
|---|---|
| `PROJECT` | Lokasi direktori utama repository. |
| `DEMO` | Lokasi direktori data pengujian. |
| `SOURCE` | Direktori sumber data yang akan dicadangkan. |
| `DEST` | Direktori tujuan penyimpanan arsip backup. |

Direktori sumber telah disediakan di dalam repository dan berisi beberapa berkas uji beserta subdirektori. Script demo-env.sh menetapkan lokasi direktori tersebut ke variabel SOURCE, sehingga pengguna tidak perlu membuat data sumber secara manual.

Periksa konfigurasi yang telah dimuat:

```bash
echo "Project : $PROJECT"
echo "Source  : $SOURCE"
echo "Dest    : $DEST"
```

Siapkan direktori tujuan backup:

```bash
mkdir -p "$DEST"
```

Periksa data sumber dan direktori tujuan:

```bash
find "$SOURCE" -maxdepth 2 -type f -print
ls -ld "$SOURCE" "$DEST"
```

Pada konfigurasi demonstrasi ini, direktori sumber menggunakan data uji yang tersedia pada `tests/demo/source`, sedangkan hasil arsip disimpan pada `output/demo-backup`.

Untuk penggunaan dengan direktori sendiri, pengguna dapat menetapkan nilai `SOURCE` dan `DEST` sesuai lokasi data yang akan dicadangkan.

### 10.3 Validasi dan Menjalankan Backup

#### A. Validasi Sumber dan Tujuan

Sebelum membuat arsip, jalankan modul `validation.sh` untuk memeriksa direktori sumber dan tujuan.

```bash
bash "$PROJECT/scripts/validation.sh" "$SOURCE" "$DEST"

VALIDATION_STATUS=$?

echo "Exit status validasi: $VALIDATION_STATUS"
```

Hasil yang diharapkan adalah pesan `Validasi berhasil` dengan exit status 0.

Apabila validasi berhasil, proses dapat dilanjutkan ke tahap backup. Jika exit status bukan 0, hentikan proses dan perbaiki penyebab kegagalan terlebih dahulu.

#### B. Menjalankan Backup

Setelah validasi berhasil, jalankan modul `backup.sh` menggunakan direktori sumber dan tujuan yang telah dikonfigurasi.

```bash
bash "$PROJECT/scripts/backup.sh" "$SOURCE" "$DEST"

BACKUP_STATUS=$?

echo "Exit status backup: $BACKUP_STATUS"
```

Backup dinyatakan berhasil apabila menghasilkan exit status 0.

Modul `backup.sh` juga menjalankan validasi secara internal sebelum membuat arsip sebagai pemeriksaan ulang.

#### C. Memeriksa Arsip Backup

Setelah backup berhasil, cari arsip terbaru pada direktori tujuan:

```bash
ARCHIVE="$(find "$DEST" \
  -maxdepth 1 -type f -name 'backup_*.tar.gz' \
  -printf '%T@ %p\n' | sort -nr | head -n 1 | cut -d' ' -f2-)"

echo "Arsip terbaru: $ARCHIVE"
```

Pastikan arsip berhasil ditemukan:

```bash
if [[ -z "$ARCHIVE" || ! -f "$ARCHIVE" ]]; then
    echo "ERROR: Arsip backup tidak ditemukan."
else
    echo "Arsip backup berhasil ditemukan."
fi
```
Jika arsip tidak ditemukan, hentikan proses dan periksa kembali hasil backup sebelum melanjutkan ke verifikasi checksum.

### 10.4 Verifikasi Checksum

Proses backup menghasilkan file checksum SHA-256 sebagai pendamping arsip. Verifikasi dilakukan untuk memastikan integritas arsip tetap terjaga.

```bash
bash "$PROJECT/scripts/verify.sh" verify "$ARCHIVE"
```

Shortcut verifikasi juga tersedia:

```bash
bash "$PROJECT/scripts/verify.sh" "$ARCHIVE"
```

### 10.5 Pemulihan Data (Restore)

Pemulihan dilakukan dengan mengekstrak arsip ke direktori pengujian yang tersedia, dapat ditulis, dan kosong.

Buat direktori tujuan restore baru:

```bash
RESTORE_DIR="$(mktemp -d "$DEMO/restore-readme.XXXXXX")"
```

Jalankan proses pemulihan:

```bash
bash "$PROJECT/scripts/restore.sh" "$ARCHIVE" "$RESTORE_DIR"
```

Bandingkan hasil pemulihan dengan direktori sumber:

```bash
diff -r "$SOURCE" "$RESTORE_DIR/$(basename "$SOURCE")"
```

Jika tidak ada output dan exit status bernilai 0, isi data hasil pemulihan identik dengan sumber.

Setelah pengujian selesai, hapus direktori restore sementara:

```bash
rm -rf -- "$RESTORE_DIR"
```

### 10.6 Monitoring CPU, Memori, dan Proses

Snapshot kondisi sistem:

```bash
bash scripts/monitoring.sh
```

Monitoring sistem berulang:

```bash
bash scripts/monitoring.sh --watch
```

Monitoring satu PID:

```bash
bash scripts/monitoring.sh --pid PID
```

Monitoring PID sampai proses selesai:

```bash
bash scripts/monitoring.sh --watch-pid PID
```

Ganti `PID` dengan nomor proses Linux yang ingin diamati.

### 10.7 Menjalankan Regression Test

Seluruh regression test lokal:

```bash
bash tests/run-regression-local.sh
```

Pengujian keamanan path:

```bash
bash tests/test-backup-path-safety.sh
```

Pengujian lock, log, dan laporan:

```bash
bash tests/test-izzul-lock-log-report.sh
```

Pengujian monitoring:

```bash
bash tests/test-monitoring-rafif.sh
```

Regression test lokal tidak menggantikan demonstrasi dan screenshot pada VM Ubuntu Server. Pengujian Docker T13–T14 dilakukan secara terpisah.

### 10.8 Pengujian Docker Read-only

Instalasi Docker pada Ubuntu Server:

```bash
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo docker pull alpine:3.21
```

Membaca laporan dari container:

```bash
sudo docker run --rm \
  --mount "type=bind,src=$PWD/output,dst=/data,readonly" \
  alpine:3.21 cat /data/laporan.txt
```

Menguji penolakan operasi append:

```bash
sudo docker run --rm \
  --mount "type=bind,src=$PWD/output,dst=/data,readonly" \
  alpine:3.21 sh -c 'echo "UJI-READ-ONLY" >> /data/laporan.txt'
```

Perintah kedua diharapkan gagal karena direktori dipasang dalam mode read-only.

### 10.9 Pembersihan Data Pengujian

Hapus direktori sementara setelah pengujian:

```bash
rm -rf -- /tmp/backup-demo
```

Pembersihan hanya dilakukan terhadap direktori data uji. Jangan menghapus `output/`, `logs/`, atau `evidence/` karena berisi laporan, log, dan bukti pengujian proyek.
