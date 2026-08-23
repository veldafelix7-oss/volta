# PANDUAN LENGKAP — Dari Nol Sampai APK Volta Terpasang di HP

Ikuti **persis** dari atas ke bawah. Jangan skip. Semua dari HP, gak perlu PC.

---

## PERSIAPAN — Install 2 aplikasi ini dulu di HP

1. **ZArchiver** (dari Play Store) — buat extract file ZIP.
2. Browser **Chrome** atau **Firefox** (biasanya udah ada).

Selesai persiapan.

---

## BAGIAN 1 — Download & Extract Project

### Langkah 1.1 — Download `volta.zip`
Di Arena.ai ini, buka file **`volta.zip`** → klik tombol **Download**. File masuk ke folder **Download** HP lu.

### Langkah 1.2 — Extract ZIP
1. Buka **ZArchiver**.
2. Masuk ke folder **Download**.
3. Tap **`volta.zip`** → pilih **Extract here**.
4. Sekarang lu punya folder **`volta`** berisi banyak file & subfolder.

### Langkah 1.3 — Cek isinya
Masuk ke folder `volta` yang baru di-extract. Lu harus lihat file/folder ini:
```
android/       ← folder
assets/        ← folder
lib/           ← folder
.gitignore
analysis_options.yaml
codemagic.yaml
pubspec.yaml
README.md
PANDUAN.md
```
Kalau semua ada, lanjut. Kalau gak lengkap, ulangi extract.

---

## BAGIAN 2 — Buat Akun & Repo GitHub

### Langkah 2.1 — Daftar GitHub (skip kalau udah punya akun)
1. Buka browser → ke **https://github.com/signup**
2. Isi email → password → username (bebas, misal `andi123`).
3. Verifikasi email lewat kode yang dikirim.
4. Pilih plan **Free**. Selesai.

### Langkah 2.2 — Buat repo baru
1. Setelah login, di kanan atas ada tombol **+** → tap → pilih **New repository**.
2. Isi form:
   - **Repository name:** ketik `volta`
   - **Description:** kosongin aja
   - Pilih **Public** (WAJIB public, biar Codemagic free bisa akses)
   - **JANGAN centang** "Add a README file"
   - **JANGAN centang** "Add .gitignore"
   - **JANGAN centang** "Choose a license"
3. Tap tombol hijau **Create repository**.

### Langkah 2.3 — Halaman "Quick setup" muncul
Jangan pencet apa-apa dulu. Scroll cari tulisan:
> **"uploading an existing file"** (link biru, biasanya di kalimat *"You can also import code…"* atau di bawah heading "…or push an existing repository")

Kalau susah nemu, langsung ganti URL browser ke:
```
https://github.com/USERNAME_LU/volta/upload/main
```
Ganti `USERNAME_LU` dengan username GitHub lu.

---

## BAGIAN 3 — Upload File (INI YANG PALING PENTING)

### ATURAN UPLOAD — BACA DULU SEBELUM MULAI
- **JANGAN upload folder `volta` sebagai satu paket.** GitHub web tidak menerima folder utuh dari HP.
- Yang di-upload adalah **ISI dari folder `volta`**, bukan foldernya.
- Struktur folder **harus dipertahankan** — GitHub bakal otomatis bikin subfolder kalau lu upload dengan cara yang benar.
- **JANGAN rename file apapun.**
- **JANGAN edit file apapun** kecuali saya suruh.

### Langkah 3.1 — Metode PALING GAMPANG dari HP: pakai GitHub Mobile App

Karena upload folder dari browser HP itu ribet, cara paling nyaman:

**Opsi A — Pakai GitHub App (RECOMMENDED)**
GitHub app resmi **tidak bisa upload file**. Skip opsi ini. Pakai Opsi B.

**Opsi B — Pakai browser HP tapi mode DESKTOP (WAJIB pakai ini)**

1. Di Chrome/Firefox, buka menu ⋮ (titik tiga kanan atas) → centang **"Desktop site"** / **"Situs desktop"**.
2. Halaman GitHub sekarang tampil seperti di PC.
3. Buka halaman upload: `https://github.com/USERNAME_LU/volta/upload/main`

### Langkah 3.2 — Upload SEMUA file & folder sekaligus

Di halaman upload GitHub ada kotak besar bertulisan **"Drag files here to add them to your repository"** dengan tombol **"choose your files"**.

1. Tap tombol **choose your files**.
2. Muncul file picker HP. Navigate ke folder **Download/volta/** hasil extract tadi.
3. **Pilih SEMUA isinya sekaligus** (long-press file pertama → tap Select All, atau tap satu-satu sampai kepilih semua).
   - Termasuk file tersembunyi `.gitignore` (kalau file picker gak nampilin file titik, aktifkan **Show hidden files** di menu file picker).
4. Tap **OK / Open / Done**.

⚠️ **MASALAH UMUM:** File picker HP biasanya cuma bisa pilih **file** satu level, gak bisa upload folder utuh. Kalau kejadian, ikuti Langkah 3.3.

### Langkah 3.3 — Kalau file picker gak bisa pilih folder (SOLUSI)

Ini metode paling reliable dari HP:

**A. Upload file di root dulu (level paling luar folder `volta`):**
1. Di file picker, masuk ke `Download/volta/`
2. Pilih file-file ini SAJA (bukan folder):
   - `.gitignore`
   - `analysis_options.yaml`
   - `codemagic.yaml`
   - `pubspec.yaml`
   - `README.md`
   - `PANDUAN.md`
3. Tap Open → tunggu semua ke-upload di halaman.
4. Scroll bawah → isi kotak **Commit changes** → tulis: `initial files`
5. Tap tombol hijau **Commit changes**.

**B. Sekarang upload folder `lib/` beserta isinya:**
1. Balik ke halaman repo lu: `https://github.com/USERNAME_LU/volta`
2. Tap tombol **Add file** → **Create new file**.
3. Di kotak nama file, ketik: `lib/main.dart` (perhatikan garis miring `/` — itu bikin GitHub otomatis buat folder `lib`)
4. Di kotak isi file, **buka file `Download/volta/lib/main.dart` di HP pakai app text editor** (bisa pakai **QuickEdit** dari Play Store, atau ZArchiver → tap file → View).
5. Copy semua isinya → paste ke kotak GitHub.
6. Scroll bawah → **Commit new file**.
7. **ULANGI langkah B ini untuk setiap file .dart di lib/:**
   - `lib/home_screen.dart`
   - `lib/services/battery_service.dart`
   - `lib/services/notification_service.dart`
   - `lib/theme/app_theme.dart`
   - `lib/widgets/top_bar.dart`
   - `lib/widgets/hero_current.dart`
   - `lib/widgets/particle_field.dart`
   - `lib/widgets/stat_card.dart`
   - `lib/widgets/footer_strip.dart`

**C. Upload folder `android/` beserta isinya:**
Sama seperti B, tap **Add file → Create new file** untuk tiap file:
- `android/build.gradle`
- `android/settings.gradle`
- `android/gradle.properties`
- `android/gradle/wrapper/gradle-wrapper.properties`
- `android/app/build.gradle`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/kotlin/com/volta/app/MainActivity.kt`
- `android/app/src/main/res/values/styles.xml`
- `android/app/src/main/res/values/colors.xml`
- `android/app/src/main/res/drawable/launch_background.xml`

**D. Upload folder `assets/` (file gambar, harus lewat upload biasa):**
1. Di halaman repo → tap **Add file → Upload files**.
2. Sebelum drop, di kolom URL browser tambahkan `/assets` di akhir:
   `https://github.com/USERNAME_LU/volta/upload/main/assets`
   Ini bikin file masuk ke folder `assets/`.
3. Pilih 2 file: `icon.png` dan `icon_fg.png` dari `Download/volta/assets/`.
4. Commit changes.

### Langkah 3.4 — Cek hasil upload
Buka `https://github.com/USERNAME_LU/volta`. Struktur harus **persis** seperti ini:
```
android/
assets/
lib/
.gitignore
PANDUAN.md
README.md
analysis_options.yaml
codemagic.yaml
pubspec.yaml
```
Kalau ada file yang belum ke-upload → ulangi langkah yang missing.

> **CATATAN JUJUR:** Upload manual satu-satu dari HP itu MEMANG capek (26 file). Kalau lu ada akses PC/laptop 5 menit doang, jauh lebih cepat drag-drop folder `volta` ke halaman upload GitHub sekali klik → langsung selesai. Kalau full dari HP, sabar aja, sekali doang kok.

---

## BAGIAN 4 — Daftar Codemagic

### Langkah 4.1 — Buka Codemagic
1. Buka `https://codemagic.io/signup`
2. Tap tombol **Sign up with GitHub**.
3. GitHub akan minta izin → tap **Authorize codemagic-io**.
4. Codemagic minta akses ke repo → pilih **All repositories** atau **Only select repositories → volta**.
5. Tap **Install & Authorize**.

### Langkah 4.2 — Tambah project
1. Setelah masuk dashboard Codemagic, tap **Add application** (tombol biru).
2. Provider: pilih **GitHub**.
3. Pilih repo **volta** dari list.
4. Project type: pilih **Flutter App**.
5. Tap **Finish: Add application**.

### Langkah 4.3 — Codemagic auto-detect config
Karena file `codemagic.yaml` udah ada di repo, Codemagic akan otomatis pakai config itu. Lu akan lihat workflow bernama **"Volta APK"**.

---

## BAGIAN 5 — Build APK

### Langkah 5.1 — Start build
1. Di halaman project Volta di Codemagic, tap tombol **Start new build** (kanan atas, warna biru).
2. Pilih:
   - **Workflow:** Volta APK (android-release)
   - **Branch:** main
3. Tap **Start new build**.

### Langkah 5.2 — Tunggu
Build pertama makan **8–15 menit** (download Flutter SDK + gradle cache dari nol). Build berikutnya jauh lebih cepat (~3 menit).

Progress bar akan jalan:
- ✅ Preparing build machine
- ✅ Fetching source code
- ✅ Get packages
- ✅ Generate launcher icons
- ✅ Analyze
- ✅ Build APK ← ini yang paling lama
- ✅ Publishing

### Langkah 5.3 — Kalau build SUCCESS (hijau ✅)
1. Scroll ke bawah, cari bagian **Artifacts**.
2. Ada file **`app-release.apk`** — tap untuk download.
3. File masuk ke folder Download HP.

### Langkah 5.4 — Kalau build FAILED (merah ❌)
1. Scroll ke bagian yang gagal (ada tanda ❌ merah).
2. Tap untuk expand log-nya.
3. Copy 20 baris terakhir log error.
4. Paste ke chat sini, kirim ke saya. Saya benerin, lu tinggal re-upload file yang diperbaiki + start build lagi.

---

## BAGIAN 6 — Install APK ke HP

### Langkah 6.1 — Izinkan install dari unknown sources
1. Buka **Settings → Apps → Special app access → Install unknown apps**.
2. Pilih browser lu (Chrome/Files) → aktifkan **Allow from this source**.

(Menu bisa beda dikit tergantung merek HP. Kalau bingung: coba install APK-nya dulu, HP akan pop-up "izinkan install dari sumber ini?" → tap **Settings** → aktifkan.)

### Langkah 6.2 — Install
1. Buka folder **Download** di HP.
2. Tap **`app-release.apk`**.
3. Tap **Install** → **Open**.

### Langkah 6.3 — Beri izin notifikasi
Saat pertama kali buka, app minta izin notifikasi → tap **Allow** biar notif colok/cabut cas jalan.

---

## SELESAI 🎉

Sekarang lu punya app **Volta** di HP. Colok charger, angka mA harus langsung nyala real-time. Cabut → notif "Charger disconnected" muncul.

---

## FAQ SINGKAT

**Q: Angka mA-nya 0 terus?**
A: Beberapa HP restrict akses `BATTERY_STATS`. Cek: nyalakan **Developer options → USB debugging** dulu, tutup app, buka lagi.

**Q: App crash saat dibuka?**
A: Kirim screenshot error / logcat ke saya.

**Q: Mau update kode?**
A: Edit file di GitHub → Codemagic bisa auto-build tiap commit (aktifkan di project settings → Triggers → "Trigger on push"). Atau manual: Start new build lagi.

**Q: Codemagic 500 menit/bulan habis?**
A: Cukup buat ~30 build. Kalau habis, pakai **GitHub Actions** (gratis unlimited untuk repo public) — bilang saya, saya buatin workflow-nya.
