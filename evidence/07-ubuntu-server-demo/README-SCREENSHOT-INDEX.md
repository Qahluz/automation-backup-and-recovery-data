# Screenshot Evidence Ubuntu Server — T01 sampai T18

Paket ini berisi screenshot terpilih untuk melengkapi bukti tekstual (`.txt`) yang sudah dibuat di repository.

## Penempatan

Ekstrak ZIP dari root repository. Isi paket akan masuk ke:
`evidence/07-ubuntu-server-demo/`

## Indeks screenshot

| ID | File | Catatan |
|---|---|---|
| T01 | `01-validation/T01-validasi-berhasil.png` | Validasi sumber dan tujuan berhasil |
| T02 | `01-validation/T02-sumber-tidak-ditemukan.png` | Sumber tidak ditemukan ditolak |
| T02b | `01-validation/T02b-sumber-bukan-direktori.png` | Sumber berupa file ditolak |
| T03 | `01-validation/T03-parameter-kurang.png` | Parameter kurang ditolak |
| T04 | `02-backup/T04-backup-berhasil-dan-detail-arsip.png` | Backup, checksum, permission arsip |
| T05 | `02-backup/T05-tujuan-readonly-ditolak.png` | Tujuan tidak writable ditolak |
| T06 | `03-checksum/T06-checksum-valid.png` | Checksum arsip cocok |
| T07 | `03-checksum/T07-checksum-arsip-dimodifikasi.png` | Modifikasi arsip terdeteksi |
| T08 | `04-restore/T08-restore-berhasil-dan-perbandingan-data.png` | Restore valid dan diff data |
| T09 | `04-restore/T09-arsip-rusak-ditolak.png` | Arsip rusak ditolak |
| T09 | `04-restore/T09-direktori-tujuan-terverifikasi-kosong.png` | Direktori tujuan dipastikan kosong |
| T10 | `06-lock-log-report/T10-dua-terminal-lock.png` | Dua proses backup dan lock |
| T10 | `06-lock-log-report/T10-terminal-1-backup-berhasil.png` | Proses pertama berhasil |
| T11 | `06-lock-log-report/T11-pemeriksaan-log-backup.png` | Isi `output/backup.log` |
| T12 | `06-lock-log-report/T12-laporan-dan-checksum-valid.png` | Laporan dan checksum arsip yang sama |
| T13 | `08-docker/T13-container-membaca-laporan-read-only.png` | Container membaca laporan |
| T14 | `08-docker/T14-append-ditolak-checksum-tetap.png` | Append ditolak dan checksum tetap |
| T15 | `06-monitoring/T15-monitoring-backup-aktif-dua-terminal.png` | Monitoring PID backup yang aktif; backup dan monitoring exit 0 |
| T16 | `06-monitoring/T16-pid-tidak-valid-ditolak.png` | PID tidak valid ditolak, exit 1 |
| T16 | `06-monitoring/T16-log-rejected-tanpa-metrik.png` | Log mencatat `STATUS=REJECTED` tanpa metrik |
| T17 | `05-access-control/T17-agung-akses-berhasil.png` | Pemilik arsip berhasil membaca |
| T18 | `05-access-control/T18-penguji-akses-ditolak.png` | Akun lain mendapat Permission denied |
| T17–T18 | `05-access-control/T17-T18-permission-arsip-600.png` | Permission 600, owner `agung:agung` |

## Catatan validasi

- T15 menggunakan screenshot terbaru dengan dua terminal: backup aktif dipantau dan kedua proses berakhir dengan exit status 0.
- T16 menggunakan PID yang dipastikan tidak aktif; screenshot percobaan PID Python yang valid dan screenshot percobaan T15/T16 lama tidak dimasukkan sebagai bukti skenario resmi.
- T09 menggunakan screenshot penolakan arsip rusak dan screenshot terpisah yang memverifikasi direktori tujuan benar-benar kosong.
- T12 menggunakan screenshot terbaru yang memeriksa keberadaan arsip, format hash, dan kesamaan checksum.
- T14 menggunakan pengujian append ke `laporan.txt` pada mount read-only, bukan hanya upaya membuat file baru.
- File `.txt` evidence tetap berada di repository dan tidak ditimpa oleh paket ini.

Screenshot adalah bukti visual pendukung. Pertahankan file output/log `.txt` dan kode sumber sebagai bukti yang dapat ditelusuri.

## Evidence pengujian tambahan

File berikut merupakan pengujian tambahan dan bukan pengganti skenario resmi dalam matriks T01-T18:

- `99-pengujian-tambahan/T15-monitoring-sistem-tambahan.txt`: pemantauan kondisi CPU dan memori sistem tanpa proses backup aktif.
- `99-pengujian-tambahan/T16-monitoring-python-tambahan.txt`: pemantauan proses Python menggunakan PID valid.
