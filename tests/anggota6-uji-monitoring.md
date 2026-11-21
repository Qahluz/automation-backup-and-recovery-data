
# Pengujian Anggota 6 - Monitoring CPU, Memori, dan Proses

Penanggung jawab: Muhammad Rafif Husein Salam (2510512202).

## 1. Prasyarat

- Sistem operasi Linux dengan Bash, `ps`, `awk`, dan direktori `/proc`.
- Script dijalankan dari repository yang sedang diuji.
- T15 menggunakan direktori data dummy dan tujuan sementara pada direktori HOME.
- T16 menggunakan PID numerik yang dipastikan tidak aktif.
- Ruang penyimpanan mencukupi untuk pembuatan data uji T15.

## 2. T15 - Monitoring ketika proses backup berjalan

### Tujuan

Memastikan PID proses backup, penggunaan CPU, dan penggunaan memori dapat diamati serta dicatat ke file log.

### Langkah pengujian

Pengujian dilakukan menggunakan dua terminal agar proses backup dapat diamati ketika masih berjalan.

Terminal 1: siapkan data pengujian dan jalankan backup.

```bash
cd ~/automation-backup-and-recovery-data

source tests/demo/demo-env.sh

T15_DIR="$(mktemp -d "$HOME/rafif-t15.XXXXXX")"

mkdir -p "$T15_DIR/sumber" "$T15_DIR/tujuan"

dd if=/dev/urandom \
  of="$T15_DIR/sumber/data-dummy.bin" \
  bs=1M count=512 status=progress
```

Jalankan backup di latar belakang dengan jeda 10 detik agar monitoring dapat dimulai sebelum proses backup berjalan.

```bash
bash -c 'sleep 10; exec bash "$1" "$2" "$3"' _ \
  "$PROJECT/scripts/backup.sh" \
  "$T15_DIR/sumber" "$T15_DIR/tujuan" \
  > "$T15_DIR/backup-output.txt" 2>&1 &

BACKUP_PID=$!

printf '%s\n' "$T15_DIR" > "$HOME/.rafif-t15-current"
printf '%s\n' "$BACKUP_PID" > "$HOME/.rafif-t15-pid"

echo "PID backup: $BACKUP_PID"
```

Terminal 2: jalankan monitoring terhadap PID backup yang sedang berjalan.

```bash
cd ~/automation-backup-and-recovery-data

source tests/demo/demo-env.sh

T15_DIR="$(cat "$HOME/.rafif-t15-current")"
BACKUP_PID="$(cat "$HOME/.rafif-t15-pid")"

bash "$PROJECT/scripts/monitoring.sh" --watch-pid "$BACKUP_PID"

MONITOR_STATUS=$?
echo "Exit status monitoring: $MONITOR_STATUS"
```

Setelah monitoring selesai, periksa hasil backup pada Terminal 1:

```bash
wait "$BACKUP_PID"

BACKUP_STATUS=$?

cat "$T15_DIR/backup-output.txt"

echo "Exit status backup: $BACKUP_STATUS"
```

### Hasil aktual

- PID yang dipantau: `33293`.
- Nama proses yang teramati: `bash`.
- Monitoring berhasil mengambil 18 sampel.
- Penggunaan CPU teramati sekitar 0,0–0,1%.
- Penggunaan memori teramati sebesar 0,1%.
- Memori RSS teramati sekitar 4320–4356 KB.
- Data pemantauan tersimpan pada `logs/monitoring.log`.
- Monitoring berhenti otomatis ketika proses selesai.
- Backup berhasil diselesaikan dengan exit status 0.
- Monitoring berhasil diselesaikan dengan exit status 0.

Status: LULUS.

### Bukti Pengujian

- `evidence/07-ubuntu-server-demo/06-monitoring/T15-monitoring-backup-aktif-dua-terminal.png`
- `evidence/07-ubuntu-server-demo/06-monitoring/T15-monitoring-backup-aktif.txt`

### Catatan Pengukuran

Nilai `%CPU` yang ditampilkan oleh `ps` merupakan rata-rata penggunaan CPU selama proses berjalan. Oleh karena itu, nilai rendah dapat muncul pada proses backup yang sebagian waktunya menunggu atau menggunakan sumber daya CPU secara singkat.

Pengujian ini mengamati PID proses backup yang dijalankan melalui Bash. Nilai CPU dan memori dicatat sesuai hasil aktual monitoring, bukan diasumsikan selalu tinggi.

## 3. T16 - Monitoring Menggunakan PID yang Tidak Valid

### Tujuan

Memastikan PID yang tidak ditemukan ditangani dengan pesan yang jelas dan tidak menghasilkan metrik CPU atau memori palsu.

### Langkah Pengujian
```bash
cd ~/automation-backup-and-recovery-data

source tests/demo/demo-env.sh
```
Muat konfigurasi lingkungan demonstrasi agar variabel PROJECT tersedia sebelum menjalankan modul monitoring.

Tentukan PID numerik yang tidak aktif:

```bash
INVALID_PID=99999999

while [[ -e "/proc/$INVALID_PID" ]]; do
    INVALID_PID=$((INVALID_PID + 1))
done

echo "PID pengujian: $INVALID_PID"
```

Jalankan monitoring:

```bash
bash "$PROJECT/scripts/monitoring.sh" --pid "$INVALID_PID"

echo "Exit status: $?"
```

Periksa pencatatan penolakan pada log:

```bash
grep -F "$INVALID_PID" "$PROJECT/logs/monitoring.log" | tail -n 5
```

### Hasil Aktual

- PID pengujian: `99999999`.
- Sistem menampilkan pesan bahwa proses tidak ditemukan, sudah berhenti, atau tidak dapat diamati.
- Monitoring menghasilkan exit status 1.
- Log mencatat penolakan dengan `STATUS=REJECTED`.
- Alasan penolakan tercatat sebagai `PID_NOT_ACTIVE_OR_NOT_VISIBLE`.
- Baris penolakan tidak menghasilkan nilai CPU, MEMORY, atau RSS_KB palsu.

Status: LULUS.

### Bukti Pengujian

- `evidence/07-ubuntu-server-demo/06-monitoring/T16-pid-tidak-valid-ditolak.png`
- `evidence/07-ubuntu-server-demo/06-monitoring/T16-monitoring-pid-invalid.txt`
- `evidence/07-ubuntu-server-demo/06-monitoring/T16-log-rejected-tanpa-metrik.png`

## 4. Pengujian Otomatis Lokal

Dari akar repository, jalankan:

```bash
bash -n scripts/monitoring.sh
bash -n tests/test-monitoring-rafif.sh
bash tests/test-monitoring-rafif.sh
```

Pengujian otomatis menggunakan salinan sementara agar tidak mengubah log atau output proyek. Hasil lokal dibedakan dari bukti pengujian yang diambil langsung dari VM Ubuntu Server kelompok.

## 5. Tabel Hasil Aktual

| ID | Hasil Aktual | Exit Status | Status |
|---|---|---|---|
| T15 | Monitoring PID 33293 berhasil mencatat 18 sampel. Backup berhasil diselesaikan. | Backup 0, monitoring 0 | LULUS |
| T16 | PID 99999999 ditolak dan dicatat sebagai STATUS=REJECTED tanpa metrik palsu. | 1 | LULUS |

## 6. Pembersihan Data Pengujian

Setelah T15 selesai, direktori sementara dapat dibersihkan menggunakan pemeriksaan path berikut:

```bash
T15_DIR="$(cat "$HOME/.rafif-t15-current")"

case "$T15_DIR" in
    "$HOME"/rafif-t15.*)
        rm -rf -- "$T15_DIR"
        echo "Direktori pengujian berhasil dibersihkan."
        ;;
    *)
        echo "Path tidak sesuai. Penghapusan dibatalkan."
        exit 1
        ;;
esac

rm -f "$HOME/.rafif-t15-current" "$HOME/.rafif-t15-pid"
```

Pembersihan hanya dilakukan terhadap direktori sementara khusus pengujian T15.

## 7. Kesimpulan

Modul `monitoring.sh` berhasil mengamati proses backup yang sedang berjalan dan mencatat informasi penggunaan CPU, memori, serta RSS. Pengujian PID tidak valid juga menunjukkan bahwa sistem dapat menolak proses yang tidak dapat diamati dan mencatat status penolakan tanpa menghasilkan metrik palsu.

Pengujian T15 dan T16 telah dilaksanakan langsung pada VM Ubuntu Server kelompok dan didokumentasikan melalui screenshot serta hasil terminal pada repository.
