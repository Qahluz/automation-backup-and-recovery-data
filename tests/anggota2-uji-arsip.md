# Pengujian Anggota 2: Pembuatan Arsip

Penanggung jawab: Muhammad Agung Budi Laksono (2510512181). Bukti: `evidence/07-ubuntu-server-demo/02-backup/`.

| Item | T04 (positif) | T05 (negatif) |
|---|---|---|
| Tujuan | Arsip terbentuk dan isinya sesuai | Tujuan tidak dapat ditulis, kegagalan dilaporkan |
| Prasyarat | Folder sumber berisi a.txt dan b.txt; folder tujuan dapat ditulis | Folder tujuan diberi izin 500 |
| Langkah | `bash scripts/backup.sh <sumber> <tujuan>` | Sama, dengan tujuan folder izin 500 |
| Hasil diharapkan | Exit 0, arsip izin 600, isi sama dengan sumber | Exit 6, direktori tujuan tidak dapat ditulis, tidak ada arsip baru |
| Hasil aktual | Exit 0, izin `-rw-------`, isi sama (diff) | Exit 6, "Direktori tujuan tidak dapat ditulis", tidak ada arsip baru |
| Status | Lulus | Lulus |
| Pemulihan | Hapus /tmp/uji | `chmod 700` pada folder tujuan |

Catatan: pada T05 kegagalan ditangkap oleh pemeriksaan folder tujuan
sebelum `tar` dijalankan, sehingga cabang kegagalan `tar` tidak diuji.

## Uji akses (T17, T18)

| Item | T17 (positif) | T18 (negatif) |
|---|---|---|
| Tujuan | Akun berwenang dapat mengakses arsip | Akun tidak berwenang ditolak |
| Prasyarat | Arsip berizin 600 milik agung; akun `penguji` dibuat | Sama |
| Langkah | `tar -tzf` sebagai agung | `sudo -u penguji tar -tzf` |
| Hasil diharapkan | Daftar isi tampil, exit 0 | Permission denied, exit bukan nol |
| Hasil aktual | Daftar isi tampil (data/, data/a.txt, data/b.txt), exit 0 | `Cannot open: Permission denied`, exit 2 |
| Status | Lulus | Lulus |
| Pemulihan | Hapus akun penguji dan agung jika keduanya dibuat khusus untuk pengujian. | Sama |

Bukti: `evidence/07-ubuntu-server-demo/05-access-control/`. Uji ini dikerjakan oleh Agung bersama Rafif.

## Pengujian regresi tambahan: keamanan path backup

Kasus tambahan ini memeriksa kombinasi path yang tidak tercakup pada T04-T05.
Pengujian otomatis berjalan pada salinan sementara dan tidak mengubah folder
sumber atau output proyek.

| Kasus | Hasil yang diharapkan | Hasil regression lokal |
|---|---|---|
| Parameter sumber kosong | Ditolak, exit 2; tidak berubah menjadi `/` | Lulus |
| Parameter tujuan kosong | Ditolak, exit 2; tidak berubah menjadi `/` | Lulus |
| Sumber berupa symbolic link ke direktori | Isi direktori target yang sebenarnya masuk ke arsip | Lulus |
| Tujuan sama dengan sumber | Ditolak, exit 7 | Lulus |
| Tujuan berada di dalam sumber | Ditolak, exit 7 | Lulus |
| Symbolic link tujuan mengarah ke dalam sumber | Ditolak setelah path diresolusikan, exit 7 | Lulus |
| Sumber `/` | Ditolak, exit 7 karena setiap tujuan berada di dalam root | Lulus |
| Nama direktori mengandung karakter glob | Pemeriksaan induk-anak tetap akurat | Lulus |

Jalankan dengan:

```bash
bash tests/test-backup-path-safety.sh
```

Catatan: pengujian regresi keamanan path merupakan pengujian tambahan yang dilaksanakan secara lokal menggunakan salinan sementara repository. Pengujian utama T04–T05 serta T17–T18 telah dilaksanakan pada VM Ubuntu Server kelompok dan didokumentasikan pada direktori evidence.
