# Portofolio Individu — Project Akhir Sistem Operasi & Praktikum Sistem Operasi

## 1. Identitas Mahasiswa
- **Nama Lengkap:** Muhammad Nur Ihsani Izzul Haq Rosyid
- **NIM:** 2510512178
- **Program Studi:** S1 Sistem Informasi — Fakultas Ilmu Komputer UPN "Veteran" Jakarta
- **Kelompok:** Kelompok 1
- **Pilihan Proyek:** 5A — Sistem Otomasi Backup dan Pemulihan Data Linux
- **Peran:** Anggota 5 (Lock Concurrency, Logging Operasional, Generator Laporan, & Aktivitas Docker)

## 2. Asal Proyek & Tim
- **Repository Utama Kelompok:** (https://github.com/AfwanNasuha/automation-backup-and-recovery-data)
- **Commit Acuan Repository Utama:** (https://github.com/AfwanNasuha/automation-backup-and-recovery-data/tree/main)
- **Anggota Kelompok:**
  1. Muhammad Afwan Imam Nasuha — Validasi sumber dan parameter
  2. Muhammad Agung Budi Laksono — Pembuatan arsip
  3. Muhammad Afaf Kafabillah — Verifikasi integritas checksum
  4. Panggi Hidayah — Pemulihan data (restore)
  5. Muhammad Nur Ihsani Izzul Haq Rosyid — Lock, log, laporan, dan Docker
  6. Muhammad Raffif Husein Salam — Pengelolaan data uji serta monitoring CPU, memori, dan proses

## 3. Kontribusi Pribadi
Pada proyek kelompok ini, saya bertanggung jawab mengembangkan modul sinkronisasi proses, pencatatan log operasional, pembuatan laporan otomatis pada `scripts/backup.sh`, serta isolasi pembacaan laporan via Docker pada `README.md`:
1. **Concurrency Lock (`flock`):** Mengimplementasikan *exclusive non-blocking lock* (`flock -n 200` pada `/tmp/backup_5a.lock`) di bagian awal eksekusi script untuk mencegah dua proses backup berjalan secara bersamaan (*race condition*).
2. **Logging Operasional:** Membuat fungsi `catat_log` yang merekam *timestamp*, PID proses, tingkat status (`INFO`/`ERROR`), dan pesan aktivitas ke `output/backup.log`.
3. **Generator Laporan:** Menyusun pembuatan laporan otomatis `output/laporan.txt` setelah arsip terverifikasi, memuat nama arsip, waktu eksekusi, nilai hash SHA-256, dan status proses.
4. **Aktivitas Docker (`readonly` Bind Mount):** Mengonfigurasi dan menguji pembacaan `output/laporan.txt` melalui container ringan `alpine:3.20` dengan pembatasan akses *read-only*.

## 4. Bukti Kontribusi Git
- **Tautan Pull Request:** (https://github.com/AfwanNasuha/automation-backup-and-recovery-data/pull/6)
- **Berkas yang Dimodifikasi:** `scripts/backup.sh`, `README.md`

## 5. Skenario Pengujian Individu
### Skenario A: Sinkronisasi Proses Bersamaan (`flock`)
- **Tujuan:** Memastikan hanya satu instansiasi proses backup yang dapat memasuki *critical section* pada satu waktu.
- **Langkah Uji:** Menjalankan dua proses `./scripts/backup.sh` secara bersamaan pada berkas dummy berukuran 50 MB.
- **Hasil Aktual:** Proses pertama (PID `1484`) berhasil memperoleh lock dan menyelesaikan backup, sedangkan proses kedua (PID `1483`) langsung ditolak dengan pesan `[ERROR] Eksekusi ditolak: proses backup lain masih berjalan.` dan keluar dengan exit status `1`.

### Skenario B: Pembacaan Laporan via Docker (Kondisi Positif — T13)
- **Tujuan:** Memverifikasi container dapat membaca laporan hasil eksekusi pada host melalui *bind mount*.
- **Perintah:**

      docker run --rm --mount type=bind,src="$(pwd)/output",dst=/data,readonly alpine:3.20 cat /data/laporan.txt

- **Hasil Aktual:** Seluruh isi `output/laporan.txt` tampil di terminal dan perintah berakhir dengan exit status `0`.

### Skenario C: Penolakan Modifikasi via Docker (Kondisi Negatif — T14)
- **Tujuan:** Memastikan pembatasan *read-only* mencegah container mengubah berkas laporan milik host.
- **Langkah & Perintah:**
  1. Menghitung checksum sebelum uji (`sha256sum output/laporan.txt`), menghasilkan `eacf5034aa86927fabaab2aaba785b6d7e4dc02fc64f691b25425bc35d2bc4a1`.
  2. Mencoba menulis ke berkas dari dalam container:

         docker run --rm --mount type=bind,src="$(pwd)/output",dst=/data,readonly alpine:3.20 sh -c 'echo "uji ubah" >> /data/laporan.txt'

  3. Memeriksa exit status (`echo $?`) dan menghitung ulang checksum setelah pengujian.
- **Hasil Aktual:** Penulisan ditolak oleh sistem dengan pesan `sh: can't create /data/laporan.txt: Read-only file system`, exit status bernilai `1`, dan hash SHA-256 setelah pengujian tetap identik (`eacf5034aa86927fabaab2aaba785b6d7e4dc02fc64f691b25425bc35d2bc4a1`).

## 6. Analisis Konsep Sistem Operasi
- **Sinkronisasi & Critical Section:** Pembuatan arsip dan penulisan laporan merupakan *critical section* yang rentan mengalami korupsi data (*race condition*) jika diakses bersamaan. Penggunaan *system call* `flock` pada *file descriptor* `200` memberikan *mutual exclusion* tingkat kernel sehingga proses kedua langsung ditolak tanpa saling menunggu (*no deadlock*).
- **Sistem Berkas & I/O:** Pencatatan log menggunakan mode *append* (`tee -a`) untuk menjaga riwayat kronologis operasi, sedangkan laporan menggunakan *overwrite* (`>`) agar mencerminkan status eksekusi terakhir. Verifikasi integritas memanfaatkan fungsi hash kriptografis SHA-256 untuk memastikan tidak ada perubahan bit pada berkas.
- **Proteksi & Isolasi Namespace (Docker):** Image `alpine:3.20` berfungsi sebagai cetak biru *read-only*, sedangkan container menjalankan proses terisolasi menggunakan *namespace* dan *cgroup* kernel. Pemetaan direktori menggunakan `--mount type=bind,...,readonly` menginstruksikan lapisan *Virtual File System* (VFS) kernel menolak seluruh *system call* penulisan pada titik kait `/data`, sementara opsi `--rm` membersihkan lapisan sementara container segera setelah proses selesai.

## 7. Kendala & Penyelesaian
- **Kendala 1 (Urutan Eksekusi Background Process):** Saat menjalankan dua perintah secara bersamaan menggunakan operator `&`, proses *foreground* terkadang dieksekusi *scheduler* kernel lebih cepat daripada proses *background*, sehingga nilai `$?` yang tertangkap adalah exit status proses yang berhasil (`0`), bukan proses yang ditolak (`1`).
  - **Penyelesaian:** Menambahkan jeda singkat (`sleep 0.2`) di antara pemanggilan proses pertama dan kedua saat pengujian agar urutan perolehan lock berjalan deterministik.
- **Kendala 2 (Autentikasi GitHub CLI):** Pengunggahan kode ke repository mengalami kegagalan autentikasi karena penggunaan kata sandi akun biasa.
  - **Penyelesaian:** Membuat *Personal Access Token* (PAT) dengan cakupan izin `repo` dan menyimpannya melalui `git config --global credential.helper store`.

## 8. Refleksi Pembelajaran
- **Hal yang Dikuasai:** Implementasi pencegahan *race condition* di shell script menggunakan `flock`, pencatatan log terstruktur berbasis PID, serta pemanfaatan *bind mount* bersifat *read-only* pada Docker untuk isolasi akses berkas.
- **Hal yang Perlu Dipelajari Lebih Lanjut:** Otomasi penjadwalan backup berkala menggunakan `systemd timer` atau `cron` serta manajemen rotasi log (`logrotate`) agar berkas log tidak membengkak pada lingkungan produksi.
