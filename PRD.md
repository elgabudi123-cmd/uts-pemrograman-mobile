# Product Requirements Document (PRD)

## Sehat Bersama Smart Village --- Aplikasi Pencarian Fasilitas Kesehatan

**Versi:** 1.0\
**Tanggal:** 8 November 2026\
**Platform:** Android\
**Teknologi implementasi:** Flutter\
**Status:** PRD MVP untuk tugas pengembangan aplikasi mobile

------------------------------------------------------------------------

## 1. Ringkasan produk

Sehat Bersama adalah aplikasi mobile yang membantu warga Desa di
Kabupaten X menemukan rumah sakit, puskesmas, dan klinik. Aplikasi
menggunakan Location-Based Service (LBS) untuk menampilkan fasilitas
berdasarkan lokasi pengguna, menghitung jarak, serta menyajikan
informasi layanan. Fitur geofencing memberikan notifikasi ketika
pengguna memasuki radius fasilitas kesehatan yang telah ditentukan.

Produk dirancang sebagai aplikasi informasi dan penunjuk lokasi, bukan
aplikasi diagnosis, konsultasi medis, atau layanan gawat darurat.

## 2. Latar belakang dan masalah

Warga yang membutuhkan layanan kesehatan bisa mengalami kesulitan ketika
tidak mengetahui fasilitas terdekat, alamat, atau jenis layanan yang
tersedia. Informasi yang tersebar membuat proses pencarian menjadi
kurang praktis, terutama bagi warga yang tidak mengenal wilayah
Kabupaten X dengan baik.

Aplikasi ini menggabungkan pencarian, daftar, peta, detail fasilitas,
dan notifikasi area dalam satu aplikasi mobile.

### Rumusan masalah produk

1.  Bagaimana warga dapat menemukan fasilitas kesehatan berdasarkan
    lokasi dan kategori?
2.  Bagaimana aplikasi menyajikan informasi alamat dan layanan dengan
    cara yang mudah dipahami?
3.  Bagaimana aplikasi memberi pemberitahuan ketika pengguna berada di
    sekitar fasilitas kesehatan tanpa mengirim notifikasi berulang?

## 3. Tujuan dan indikator keberhasilan

### Tujuan

-   Mempermudah pencarian fasilitas kesehatan.
-   Menyediakan informasi fasilitas dalam format yang konsisten.
-   Menampilkan lokasi fasilitas dan jarak dari pengguna.
-   Memberikan notifikasi geofence dengan perilaku yang terkendali.
-   Menyediakan pengalaman yang tetap berguna ketika izin lokasi tidak
    diberikan.

### Indikator keberhasilan MVP

  -----------------------------------------------------------------------
  Indikator                           Target uji
  ----------------------------------- -----------------------------------
  Pencarian fasilitas                 Hasil yang sesuai muncul untuk
                                      nama, kategori, atau layanan yang
                                      ada di dataset

  Filter kategori                     Daftar dan marker berubah sesuai
                                      filter

  Detail fasilitas                    Seluruh field wajib dari data yang
                                      tersedia ditampilkan

  Jarak                               Nilai jarak tampil hanya jika
                                      koordinat dan izin lokasi valid

  Favorit                             Fasilitas dapat disimpan dan tetap
                                      tersimpan setelah aplikasi dibuka
                                      ulang

  Navigasi                            Aplikasi peta eksternal terbuka
                                      dengan koordinat tujuan yang benar

  Geofence                            Satu peristiwa masuk menghasilkan
                                      maksimal satu notifikasi dalam
                                      periode cooldown

  Penanganan izin                     Daftar dan detail tetap dapat
                                      dipakai tanpa izin lokasi

  Stabilitas                          Tidak ada crash pada alur utama
                                      dalam pengujian perangkat target
  -----------------------------------------------------------------------

Target tersebut merupakan kriteria pengujian prototipe, bukan klaim
performa produksi.

## 4. Pengguna dan kebutuhan

### Persona utama: warga

Kebutuhan: - Menemukan RS, puskesmas, atau klinik. - Mengetahui jarak
dan alamat. - Memeriksa layanan yang tersedia. - Membuka petunjuk menuju
lokasi. - Menyimpan fasilitas yang sering digunakan.

Hambatan: - Tidak mengetahui nama fasilitas. - Belum memahami wilayah. -
Koneksi internet atau GPS dapat tidak stabil.

### Persona sekunder: pengelola data

Kebutuhan: - Memasukkan data fasilitas yang benar. - Memperbarui
koordinat, jam operasional, nomor kontak, dan layanan. - Menghapus
informasi yang sudah tidak berlaku.

Pada MVP, pengelola data menyiapkan dataset JSON lokal. Antarmuka admin
belum dibangun.

## 5. Ruang lingkup

### Termasuk dalam MVP

1.  Beranda.
2.  Pencarian fasilitas.
3.  Filter rumah sakit, puskesmas, dan klinik.
4.  Daftar fasilitas.
5.  Peta dan marker.
6.  Lokasi pengguna dan estimasi jarak.
7.  Detail fasilitas dan daftar layanan.
8.  Favorit lokal.
9.  Tombol membuka navigasi eksternal.
10. Geofence dengan radius yang dapat dikonfigurasi.
11. Notifikasi lokal saat masuk area geofence.
12. Penanganan izin lokasi dan notifikasi.
13. State loading, empty, error, dan offline.

### Tidak termasuk dalam MVP

-   Akun pengguna dan autentikasi.
-   Dashboard admin.
-   Backend produksi dan sinkronisasi langsung.
-   Pembayaran, booking, dan antrean.
-   Konsultasi atau diagnosis medis.
-   Rekam medis.
-   Pelacakan lokasi tanpa henti.
-   Navigasi turn-by-turn internal.
-   Integrasi langsung dengan sistem informasi rumah sakit.

## 6. Kebutuhan fungsional

  -----------------------------------------------------------------------
  ID                      Kebutuhan               Prioritas
  ----------------------- ----------------------- -----------------------
  FR-01                   Sistem menampilkan      Must
                          beranda dan kategori    
                          fasilitas kesehatan     

  FR-02                   Pengguna dapat mencari  Must
                          fasilitas berdasarkan   
                          nama                    

  FR-03                   Pengguna dapat mencari  Must
                          berdasarkan alamat atau 
                          nama layanan yang       
                          tercatat                

  FR-04                   Pengguna dapat          Must
                          memfilter RS,           
                          puskesmas, klinik, atau 
                          semua                   

  FR-05                   Sistem menampilkan      Must
                          daftar fasilitas dari   
                          dataset                 

  FR-06                   Sistem menampilkan      Must
                          marker fasilitas pada   
                          peta                    

  FR-07                   Sistem menampilkan      Must
                          posisi pengguna setelah 
                          izin lokasi diberikan   

  FR-08                   Sistem menghitung dan   Must
                          menampilkan jarak       
                          pengguna ke fasilitas   

  FR-09                   Pengguna dapat membuka  Must
                          detail fasilitas        

  FR-10                   Detail menampilkan      Must
                          alamat, jenis           
                          fasilitas, layanan, dan 
                          informasi kontak jika   
                          tersedia                

  FR-11                   Pengguna dapat membuka  Must
                          lokasi fasilitas di     
                          aplikasi peta eksternal 

  FR-12                   Pengguna dapat menambah Should
                          dan menghapus fasilitas 
                          dari favorit            

  FR-13                   Favorit tetap tersedia  Should
                          setelah aplikasi        
                          dimulai ulang           

  FR-14                   Pengguna dapat          Should
                          mengaktifkan atau       
                          menonaktifkan           
                          notifikasi geofence     

  FR-15                   Sistem mendeteksi       Should
                          pengguna memasuki       
                          radius geofence dan     
                          mengirim notifikasi     
                          lokal                   

  FR-16                   Sistem mencegah         Should
                          notifikasi masuk        
                          berulang untuk          
                          fasilitas yang sama     
                          dalam periode cooldown  

  FR-17                   Sistem memberi          Must
                          penjelasan ketika izin  
                          lokasi/notifikasi tidak 
                          tersedia                

  FR-18                   Pengguna dapat kembali  Must
                          ke daftar jika peta     
                          gagal dimuat            
  -----------------------------------------------------------------------

**Catatan prioritas:** jika waktu pengerjaan terbatas, selesaikan FR-01
sampai FR-11 dan FR-17 sampai FR-18 lebih dahulu. Geofence latar
belakang merupakan bagian paling berisiko secara teknis dan perlu diuji
pada perangkat fisik.

## 7. Kebutuhan nonfungsional

  -----------------------------------------------------------------------
  ID                      Kategori                Persyaratan
  ----------------------- ----------------------- -----------------------
  NFR-01                  Usability               Alur pencarian sampai
                                                  detail dapat dilakukan
                                                  dengan navigasi yang
                                                  konsisten

  NFR-02                  Performance             Daftar lokal
                                                  ditampilkan tanpa
                                                  menunggu pemuatan tile
                                                  peta

  NFR-03                  Reliability             Kegagalan peta atau GPS
                                                  tidak menyebabkan
                                                  aplikasi berhenti

  NFR-04                  Compatibility           Aplikasi ditargetkan
                                                  untuk perangkat Android
                                                  yang mendukung versi
                                                  Flutter dan plugin yang
                                                  dipilih

  NFR-05                  Security                Izin lokasi hanya
                                                  diminta ketika
                                                  dibutuhkan; lokasi
                                                  tidak dikirim ke server
                                                  pada MVP

  NFR-06                  Privacy                 Aplikasi tidak meminta
                                                  nama lengkap, nomor
                                                  identitas, atau data
                                                  medis untuk fitur
                                                  pencarian

  NFR-07                  Accessibility           Teks terbaca, kontras
                                                  cukup, dan ikon aksi
                                                  memiliki label

  NFR-08                  Maintainability         Logika lokasi, data,
                                                  dan tampilan dipisahkan
                                                  agar dapat diuji

  NFR-09                  Data integrity          Koordinat dan ID
                                                  fasilitas harus valid
                                                  dan unik

  NFR-10                  Battery                 Pemantauan lokasi
                                                  dibatasi pada kebutuhan
                                                  fitur; hindari polling
                                                  GPS terus-menerus tanpa
                                                  alasan

  NFR-11                  Offline handling        Data fasilitas lokal
                                                  tetap dapat dibaca
                                                  tanpa internet; peta
                                                  online dapat tidak
                                                  tersedia

  NFR-12                  Transparency            Jarak ditandai sebagai
                                                  estimasi garis lurus,
                                                  bukan jarak tempuh
                                                  jalan
  -----------------------------------------------------------------------

## 8. User stories dan acceptance criteria

### US-01 --- Mencari fasilitas kesehatan

**Sebagai warga, saya ingin mencari nama fasilitas agar dapat menemukan
tempat yang saya butuhkan.**

Acceptance criteria: - Pengguna dapat memasukkan kata kunci. - Hasil
cocok dengan nama fasilitas. - Hasil yang kosong menampilkan pesan yang
jelas. - Pengguna dapat menghapus kata kunci dan melihat daftar kembali.

### US-02 --- Memfilter kategori

**Sebagai warga, saya ingin memilih kategori agar daftar hanya
menampilkan jenis fasilitas yang relevan.**

Acceptance criteria: - Pilihan kategori terdiri dari Semua, Rumah Sakit,
Puskesmas, dan Klinik. - Daftar dan marker mengikuti kategori aktif. -
Pengguna dapat kembali ke Semua.

### US-03 --- Melihat lokasi dan jarak

**Sebagai warga, saya ingin melihat posisi fasilitas dan jaraknya dari
lokasi saya.**

Acceptance criteria: - Aplikasi meminta izin lokasi saat fitur lokasi
digunakan. - Jika izin diberikan dan koordinat valid, posisi pengguna
serta jarak ditampilkan. - Jika izin ditolak, daftar tetap dapat
digunakan dan jarak tidak dibuat-buat. - Label jarak menjelaskan bahwa
nilai merupakan jarak garis lurus.

### US-04 --- Melihat detail fasilitas

**Sebagai warga, saya ingin melihat layanan dan alamat sebelum
mengunjungi fasilitas.**

Acceptance criteria: - Detail menampilkan informasi yang tersedia pada
dataset. - Layanan ditampilkan dengan nama dan ikon yang sesuai. -
Informasi yang tidak tersedia tidak diganti dengan data rekaan.

### US-05 --- Menyimpan favorit

**Sebagai warga, saya ingin menyimpan fasilitas yang sering saya
gunakan.**

Acceptance criteria: - Tombol favorit menambah atau menghapus
fasilitas. - Perubahan terlihat pada halaman Favorit. - Data favorit
tetap tersedia setelah aplikasi dimulai ulang.

### US-06 --- Mendapat notifikasi geofence

**Sebagai warga, saya ingin mendapat pemberitahuan ketika memasuki area
fasilitas kesehatan.**

Acceptance criteria: - Radius awal ditetapkan 500 meter dan dapat diubah
melalui konfigurasi. - Notifikasi hanya dikirim pada peristiwa masuk. -
Notifikasi tidak berulang terus-menerus saat pengguna masih berada di
dalam area. - Mengetuk notifikasi membuka detail fasilitas. - Jika izin
atau kemampuan sistem tidak mendukung, aplikasi menjelaskan bahwa fitur
tidak aktif.

## 9. Alur utama pengguna

### Alur A --- Menemukan fasilitas terdekat

1.  Pengguna membuka aplikasi.
2.  Beranda menampilkan kategori dan daftar fasilitas.
3.  Pengguna memilih kategori atau memasukkan kata kunci.
4.  Aplikasi menampilkan hasil.
5.  Jika pengguna mengizinkan lokasi, hasil dapat diurutkan berdasarkan
    jarak.
6.  Pengguna memilih satu fasilitas.
7.  Aplikasi membuka detail.
8.  Pengguna memilih Lihat di Peta atau Mulai Navigasi.

### Alur B --- Menggunakan peta

1.  Pengguna membuka menu Peta.
2.  Aplikasi menjelaskan kebutuhan akses lokasi.
3.  Pengguna memberi izin.
4.  Peta menampilkan posisi pengguna dan marker fasilitas.
5.  Pengguna memilih marker.
6.  Ringkasan fasilitas muncul.
7.  Pengguna membuka detail atau navigasi eksternal.

### Alur C --- Geofence

1.  Pengguna mengaktifkan fitur notifikasi area.
2.  Aplikasi meminta izin yang diperlukan dan menjelaskan penggunaannya.
3.  Sistem mendaftarkan geofence fasilitas yang masuk cakupan MVP.
4.  Perangkat mendeteksi transisi masuk.
5.  Aplikasi memeriksa cooldown dan status notifikasi.
6.  Jika memenuhi aturan, notifikasi lokal dikirim.
7.  Pengguna mengetuk notifikasi dan masuk ke detail fasilitas.

## 10. Aturan bisnis

1.  Kategori fasilitas hanya salah satu dari `hospital`, `puskesmas`,
    atau `clinic`.
2.  Setiap fasilitas wajib memiliki ID unik, nama, alamat, latitude, dan
    longitude.
3.  Data yang tidak diketahui harus bernilai null atau ditandai belum
    tersedia.
4.  Jarak dihitung hanya jika koordinat pengguna dan fasilitas valid.
5.  Pengurutan jarak hanya aktif jika lokasi pengguna tersedia.
6.  Radius geofence default adalah 500 meter.
7.  Notifikasi hanya dikirim pada transisi masuk.
8.  Cooldown default dapat ditetapkan 30 menit per fasilitas untuk
    mencegah notifikasi berulang; nilainya dapat disesuaikan saat
    pengujian.
9.  Navigasi dilakukan oleh aplikasi peta eksternal.
10. Data contoh dalam pengembangan harus diberi label simulasi.

## 11. Data dan integrasi

### Sumber data MVP

Gunakan file JSON lokal berisi data simulasi atau data yang telah
diverifikasi. Struktur minimal:

``` json
{
  "id": "facility-001",
  "name": "Nama Fasilitas",
  "type": "hospital",
  "address": "Alamat yang telah diverifikasi",
  "latitude": -6.2,
  "longitude": 106.8,
  "phone": null,
  "openingHours": null,
  "services": ["Poli Umum", "Laboratorium"],
  "geofenceRadiusMeters": 500
}
```

Nilai koordinat di atas hanya contoh format, bukan koordinat fasilitas
sebenarnya.

### Integrasi perangkat

-   GPS/location provider untuk posisi pengguna.
-   Peta berbasis OpenStreetMap melalui library yang dipilih.
-   Notifikasi lokal untuk pemberitahuan geofence.
-   Aplikasi peta eksternal untuk navigasi.

### Pertimbangan data peta

Aplikasi memerlukan koneksi internet untuk memuat tile peta online.
Penggunaan tile harus mematuhi ketentuan penyedia. Untuk penggunaan
produksi, pilih penyedia tile yang sesuai dengan volume dan kebijakan
penggunaan.

## 12. Arsitektur teknis tingkat tinggi

Pola: Flutter dengan pemisahan Presentation, Domain, dan Data.

``` text
Flutter UI
   |
   v
Feature State / Controller
   |
   v
Use Cases / Domain Rules
   |
   v
Repositories
   |----------------------|
   v                      v
Local JSON / Storage   Device Services
                       - Location
                       - Geofence
                       - Local Notification
                       - External Maps
```

Fitur inti: - Home - Facility Search & List - Map - Facility Detail -
Favorites - Profile / Permissions - Geofence & Notifications

Repository digunakan agar sumber data lokal dapat diganti dengan API di
tahap berikutnya tanpa mengubah seluruh UI.

## 13. Risiko dan mitigasi

  -----------------------------------------------------------------------
  Risiko                  Dampak                  Mitigasi
  ----------------------- ----------------------- -----------------------
  GPS tidak akurat        Jarak atau posisi       Tampilkan akurasi bila
                          kurang tepat            perlu; jangan mengklaim
                                                  presisi tinggi

  Izin lokasi ditolak     Fitur jarak/geofence    Sediakan daftar dan
                          tidak berjalan          pencarian tanpa lokasi

  Batasan background      Geofence terlambat atau Uji perangkat fisik,
  Android                 tidak terpicu           jelaskan batasan, ikuti
                                                  kebijakan izin Android

  Tile peta gagal         Peta tidak tampil       Sediakan tampilan
                                                  daftar dan pesan coba
                                                  lagi

  Dataset tidak akurat    Warga mendapat          Verifikasi sumber,
                          informasi keliru        tanggal pembaruan, dan
                                                  penanggung jawab data

  Notifikasi berulang     Mengganggu pengguna     Cooldown dan pencatatan
                                                  status geofence

  Plugin tidak kompatibel Build gagal             Kunci versi dependensi
                                                  dan uji integrasi sejak
                                                  awal
  -----------------------------------------------------------------------

## 14. Rencana pengujian MVP

  -----------------------------------------------------------------------
  ID                      Skenario                Hasil yang diharapkan
  ----------------------- ----------------------- -----------------------
  TC-01                   Membuka aplikasi        Beranda tampil

  TC-02                   Mencari nama yang ada   Fasilitas terkait
                                                  muncul

  TC-03                   Mencari kata yang tidak Empty state tampil
                          ada                     

  TC-04                   Memilih kategori klinik Hanya klinik yang
                                                  tampil

  TC-05                   Membuka detail          Informasi fasilitas
                                                  tampil sesuai dataset

  TC-06                   Menolak izin lokasi     Daftar tetap dapat
                                                  digunakan

  TC-07                   Memberi izin lokasi     Posisi dan jarak tampil
                                                  jika GPS tersedia

  TC-08                   Menyimpan favorit       Fasilitas masuk ke
                                                  halaman Favorit

  TC-09                   Menutup dan membuka     Favorit tetap tersimpan
                          aplikasi                

  TC-10                   Menekan Mulai Navigasi  Aplikasi peta eksternal
                                                  terbuka dengan tujuan
                                                  benar

  TC-11                   Memasuki geofence       Notifikasi masuk muncul
                                                  sesuai izin dan
                                                  dukungan perangkat

  TC-12                   Tetap berada di dalam   Tidak ada notifikasi
                          radius                  berulang selama
                                                  cooldown

  TC-13                   Tile peta gagal         Pesan error dan
                                                  alternatif daftar
                                                  tersedia

  TC-14                   Internet dimatikan      Data lokal tetap bisa
                                                  ditampilkan
  -----------------------------------------------------------------------

Pengujian geofence perlu dilakukan pada perangkat Android fisik dengan
variasi kondisi izin, layar mati, penghemat baterai, dan koneksi. Hasil
dapat berbeda antar merek dan versi Android.

## 15. Rencana pengerjaan

Urutan implementasi yang disarankan:

1.  Buat proyek Flutter dan struktur folder.
2.  Siapkan model Facility dan dataset JSON.
3.  Bangun tema, navigasi bawah, dan komponen umum.
4.  Implementasikan Beranda, pencarian, filter, dan daftar.
5.  Implementasikan halaman detail dan favorit lokal.
6.  Integrasikan lokasi dan perhitungan jarak.
7.  Integrasikan peta dan marker.
8.  Tambahkan navigasi eksternal.
9.  Implementasikan notifikasi lokal dan geofence.
10. Uji seluruh alur pada perangkat Android.
11. Rapikan dokumentasi, tangkapan layar, dan laporan pengujian.

## 16. Definition of Done

Fitur dinyatakan selesai apabila: - Kode dapat dijalankan pada perangkat
target. - Alur normal dan kondisi gagal telah diuji. - Tidak ada data
fiktif yang ditampilkan sebagai data resmi. - Izin lokasi dan notifikasi
diminta secara kontekstual. - Pesan error dapat dipahami pengguna. -
Kriteria acceptance criteria fitur terpenuhi. - Perubahan penting dan
dependensi dicatat dalam dokumentasi proyek.

## 17. Asumsi dan keputusan yang perlu dikonfirmasi

1.  Kabupaten X masih nama wilayah placeholder. Nama wilayah sebenarnya
    dan dataset fasilitas perlu ditentukan.
2.  Belum ada API resmi yang disebutkan. Karena itu MVP menggunakan
    dataset lokal.
3.  Target awal Android, bukan iOS.
4.  Radius geofence default 500 meter.
5.  Navigasi dilakukan melalui aplikasi peta eksternal.
6.  Akun pengguna dan dashboard admin tidak termasuk MVP.
7.  Jam buka, rating, nomor telepon, dan layanan hanya ditampilkan jika
    sumbernya tersedia dan dapat diverifikasi.

------------------------------------------------------------------------

## Catatan anti-AI-slop untuk pengerjaan

Dokumen ini sengaja membatasi fitur pada kebutuhan yang dapat dijelaskan
dan diuji. Saat implementasi dan penulisan laporan:

-   Jangan menulis klaim seperti "real-time dan akurat 100%" untuk GPS
    atau geofence.
-   Jangan membuat statistik, rating, nama rumah sakit, alamat, atau jam
    operasional yang tidak bersumber.
-   Jangan menambahkan login, chat AI, rekam medis, atau fitur besar
    lain tanpa kebutuhan dan waktu pengerjaan.
-   Jangan menyebut geofence sebagai pelacakan terus-menerus.
-   Jelaskan alasan pemilihan library berdasarkan fungsi yang
    benar-benar dipakai.
-   Sertakan bukti pengujian dari perangkat, bukan hanya screenshot
    desain.
-   Jika fitur belum berhasil, tulis sebagai keterbatasan, bukan
    mengklaim sudah selesai.
-   Gunakan bahasa yang spesifik terhadap aplikasi ini. Hindari kalimat
    promosi umum seperti "memberikan pengalaman terbaik dan
    revolusioner".
