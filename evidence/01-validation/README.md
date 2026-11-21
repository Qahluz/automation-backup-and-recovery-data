
# Bukti Pengujian Modul Validasi — Afwan

Direktori ini menyimpan bukti pengujian lokal modul `scripts/validation.sh` yang dilakukan menggunakan CachyOS dan Bash.

Bukti pada direktori ini merupakan pengujian tambahan dan dokumentasi pengembangan lokal. Bukti resmi pengujian T01–T03 pada VM Ubuntu Server kelompok tersedia di `evidence/07-ubuntu-server-demo/01-validation/`.

## 1. Daftar Bukti Pengujian Lokal

| Berkas Bukti | Isi Bukti | Skenario |
|---|---|---|
| `Screenshot_20261114_165124.png` | Direktori sumber dan tujuan valid diterima | T01 lokal |
| `Screenshot_20261114_165133.png` | Sumber tidak tersedia ditolak dengan exit status 3 | T02 lokal |
| `Screenshot_20261114_165157.png` | Parameter tidak diberikan, parameter kosong, dan direktori tujuan tidak ditemukan | T03, V01, V03 |
| `V02-sumber-bukan-direktori.png` | Sumber berupa berkas biasa ditolak dengan exit status 3 | V02 |
| `Screenshot_20261114_165206.png` | Pemeriksaan permission sumber dan tujuan | Pendukung |
| `Screenshot_uji_nonroot_valid_dan_tujuan.png` | Akun `validationtester` berhasil menggunakan direktori valid dan ditolak saat tujuan tidak dapat ditulis | V04, V06 |
| `Screenshot_uji_nonroot_sumber.png` | Akun `validationtester` ditolak saat sumber tidak dapat diakses | V05 |
| `Screenshot_pemeriksaan_sintaks_dan_eksekusi.png` | Pemeriksaan sintaks Bash dan eksekusi langsung modul | Pendukung |

## 2. Pengujian Resmi Ubuntu Server

Pengujian utama T01–T03 telah dilaksanakan pada VM Ubuntu Server kelompok.

| ID | Skenario | Hasil Aktual | Exit Status | Status |
|---|---|---|---:|---|
| T01 | Sumber dan tujuan valid | Validasi berhasil | 0 | Lulus |
| T02 | Sumber tidak ditemukan | Direktori sumber tidak ditemukan | 3 | Lulus |
| T02 tambahan | Sumber berupa file, bukan direktori | Sumber bukan direktori | 3 | Lulus |
| T03 | Parameter wajib tidak diberikan | Parameter harus terdiri dari sumber dan tujuan | 2 | Lulus |

Bukti resmi tersedia pada:

`evidence/07-ubuntu-server-demo/01-validation/`

## 3. Pengujian Tambahan Lokal

Pengujian tambahan V01–V06 dilakukan menggunakan CachyOS dan akun non-root `validationtester`.

Pengujian meliputi parameter kosong, sumber bukan direktori, tujuan tidak ditemukan, penggunaan direktori valid oleh akun non-root, sumber tanpa izin akses, dan tujuan tanpa izin tulis.

Hasil rinci tersedia pada `tests/anggota1-uji-validasi.md`.

## 4. Catatan

1. Screenshot dalam direktori ini merupakan bukti pengembangan dan pengujian tambahan lokal.
2. Bukti resmi skenario kelompok T01–T03 menggunakan hasil pengujian langsung pada Ubuntu Server.
3. Pengujian lokal dan pengujian Ubuntu Server dibedakan agar tidak terjadi pencampuran lingkungan maupun hasil aktual.
