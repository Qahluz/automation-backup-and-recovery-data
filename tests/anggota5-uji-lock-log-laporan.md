# Lembar Pengujian Anggota 5 - T10 sampai T12

## Informasi Pengujian

- Penanggung jawab: Muhammad Nur Ihsani Izzul Haq Rosyid (2510512178)
- Lingkungan pengujian: VM Ubuntu Server kelompok
- Script utama: `scripts/backup.sh`
- File lock: `output/backup_5a.lock`
- File log: `output/backup.log`
- File laporan: `output/laporan.txt`
- Tanggal pengujian: 19–20 November 2026

## T10 - Pengujian Lock Dua Proses Backup

Tujuan: memastikan proses backup kedua ditolak selama proses backup pertama masih memegang lock.

| Item | Proses pertama (positif) | Proses kedua (negatif) |
|---|---|---|
| Tujuan | Memastikan backup berhasil memperoleh lock. | Memastikan proses backup kedua ditolak saat lock aktif. |
| Prasyarat | Direktori sumber dan tujuan valid serta `flock` tersedia. | Proses backup pertama masih memegang lock. |
| Hasil aktual | Lock berhasil diperoleh. Backup selesai dan arsip berhasil dibuat. | Eksekusi ditolak dengan pesan `Eksekusi ditolak: proses backup lain masih berjalan.` |
| PID | 5717 | 5766 |
| Exit status | 0 | 1 |
| Status | LULUS | LULUS |

Bukti:
- `evidence/07-ubuntu-server-demo/06-lock-log-report/T10-dua-terminal-lock.png`
- `evidence/07-ubuntu-server-demo/06-lock-log-report/T10-terminal-1-backup-berhasil.png`
- `evidence/07-ubuntu-server-demo/06-lock-log-report/T10-proses-pertama.txt`
- `evidence/07-ubuntu-server-demo/06-lock-log-report/T10-proses-kedua.txt`

## T11 - Pengujian Pencatatan Log

Tujuan: memastikan aktivitas backup dan penolakan proses akibat lock tercatat pada file log.

Pemeriksaan dilakukan terhadap `output/backup.log`.

Hasil aktual:
- File log ditemukan dan tidak kosong.
- Ukuran file: 6196 bytes.
- Permission: 600.
- Aktivitas memperoleh lock oleh PID 5717 tercatat.
- Penolakan proses kedua oleh PID 5766 tercatat.
- Keberhasilan backup pertama tercatat.
- Setiap catatan aktivitas memuat waktu, PID, tingkat pesan, dan keterangan.

Status: LULUS.

Bukti:
- `evidence/07-ubuntu-server-demo/06-lock-log-report/T11-pemeriksaan-log-backup.png`
- `evidence/07-ubuntu-server-demo/06-lock-log-report/T11-pemeriksaan-log-backup.txt`

## T12 - Pengujian Laporan Backup

Tujuan: memastikan laporan backup memuat informasi arsip dan checksum yang sesuai dengan hasil pembuatan arsip.

Hasil aktual:
- Laporan `output/laporan.txt` berhasil dibuat.
- Nama arsip: `backup_20261120_142557_33922.tar.gz`.
- Waktu eksekusi: 20 November 2026, 14:25:57.
- PID: 33922.
- Status proses: BERHASIL.
- Hasil verifikasi: LOLOS.
- Checksum SHA-256 pada laporan cocok dengan checksum aktual arsip.
- Checksum: `6d4716093a6f959f6a2d7b044ec83919d8d55f7a21d00c54ed3c7ae95558a830`.
- Exit status backup: 0.

Status: LULUS.

Bukti:
- `evidence/07-ubuntu-server-demo/06-lock-log-report/T12-laporan-dan-checksum-valid.png`
- `evidence/07-ubuntu-server-demo/06-lock-log-report/T12-refresh-laporan.txt`

## Pemeriksaan Izin File Log

Pemeriksaan dilakukan terhadap file log backup untuk memastikan hak aksesnya dibatasi kepada pemilik file.

Hasil pemeriksaan:

- File: `output/backup.log`
- Permission: `600`
- Ukuran: `6196 bytes`

Status: LULUS.

Bukti pemeriksaan: `evidence/07-ubuntu-server-demo/06-lock-log-report/T11-pemeriksaan-log-backup.txt`

## Catatan

Pengujian T10–T12 dilaksanakan langsung pada VM Ubuntu Server kelompok. Hasil aktual, PID, exit status, log, laporan, dan screenshot mengacu pada bukti pelaksanaan yang tersimpan di repository.
