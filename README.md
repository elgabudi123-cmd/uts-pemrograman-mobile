# Sehat Bersama

Aplikasi Flutter Android untuk mencari fasilitas kesehatan berdasarkan PRD
Sehat Bersama Smart Village.

## Menjalankan aplikasi

1. Pasang Flutter stable dan Android SDK.
2. Jalankan `flutter pub get`.
3. Hubungkan perangkat Android atau jalankan emulator.
4. Jalankan `flutter run`.

Peta menggunakan tile OpenStreetMap dan memerlukan internet. Daftar dan
favorit tersimpan secara lokal. Izin lokasi baru diminta ketika pengguna
memakai fitur lokasi. Atribusi OpenStreetMap ditampilkan pada peta; tile
publik dipakai untuk pengembangan dan harus mengikuti kebijakan penyedia.
Untuk penggunaan produksi, pilih penyedia tile sesuai volume penggunaan.

## Data fasilitas

Dataset MVP ada di `assets/data/facilities.json`. Seluruh entri saat ini
adalah **data simulasi** dengan koordinat contoh, bukan lokasi fasilitas
terverifikasi. Karena itu aplikasi tidak menampilkan jarak atau mengaktifkan
geofence untuk entri tersebut. Telepon dan jam operasional bernilai `null`
hingga sumber data tepercaya tersedia.

Sebelum digunakan di lapangan, ganti data simulasi dengan data yang telah
diverifikasi dan pastikan koordinat, alamat, layanan, serta informasi kontak
akurat. Setiap entri harus memiliki ID unik dan nilai `isSimulation: false`
agar jarak dan geofence dapat digunakan.

## Batasan MVP

- Navigasi dibuka pada aplikasi peta eksternal; aplikasi tidak menyediakan
  panduan belokan internal.
- Pemantauan geofence hanya berlangsung selama aplikasi aktif dan tidak
  berjalan di latar belakang. Radius disimpan pada konfigurasi tiap fasilitas
  dan nilai awalnya 500 meter.
- Peta dapat gagal dimuat tanpa internet; daftar lokal tetap dapat digunakan.

## Validasi

Jalankan `flutter analyze` dan `flutter test` untuk pemeriksaan statis dan tes
model/dataset.
