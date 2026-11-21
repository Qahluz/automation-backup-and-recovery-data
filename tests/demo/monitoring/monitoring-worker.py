import time

data = bytearray(64 * 1024 * 1024)

print("Worker berjalan.")
print("Alokasi memori: 64 MiB")

end_time = time.monotonic() + 20
counter = 0

while time.monotonic() < end_time:
    counter = (counter + 1) % 1000003

print("Worker selesai.")
