# Volta — Panduan Build APK Dari HP (Codemagic)

Proyek Flutter lengkap. Lu **gak perlu install apa-apa di HP**. Semua build jalan di server Codemagic (gratis 500 menit/bulan). Ikuti langkah persis dari atas ke bawah.

---

## LANGKAH 1 — Download folder `volta/` sebagai ZIP

Di Arena.ai, klik ikon menu di file manager → **Download workspace** (atau download folder `volta`). Lu akan dapet file `volta.zip`.

## LANGKAH 2 — Upload ke GitHub (butuh, karena Codemagic tarik dari repo Git)

1. Buka **https://github.com** di browser HP → daftar/login (gratis).
2. Klik tombol hijau **New** (buat repo baru).
3. Nama repo: `volta`. Set **Public**. Centang **Add a README file**. Klik **Create repository**.
4. Di halaman repo, klik tombol **Add file → Upload files**.
5. Extract dulu `volta.zip` di HP (pakai app **ZArchiver** atau **Files by Google**).
6. Di halaman upload GitHub, drag/select **semua isi folder volta** (bukan foldernya, isinya — file `pubspec.yaml`, folder `lib`, `android`, `assets`, dll).
7. Scroll ke bawah → **Commit changes**.

## LANGKAH 3 — Daftar Codemagic & connect repo

1. Buka **https://codemagic.io/signup** → **Sign up with GitHub** (paling cepat).
2. Otorisasi Codemagic akses ke akun GitHub lu.
3. Setelah masuk dashboard, klik **Add application**.
4. Pilih **GitHub** sebagai provider → pilih repo **volta** → **Next**.
5. Project type: pilih **Flutter App (via workflow editor)** atau **codemagic.yaml** (file `codemagic.yaml` udah ada di project, jadi dia auto-detect).
6. Klik **Finish**.

## LANGKAH 4 — Build

1. Di halaman project Codemagic, klik tombol **Start new build** (kanan atas).
2. Workflow: **android-release**. Branch: **main**.
3. Klik **Start build**.
4. Tunggu ~7–12 menit (build pertama paling lama karena download Flutter + gradle cache).

## LANGKAH 5 — Download APK

1. Setelah build **Success (hijau)**, scroll ke bawah bagian **Artifacts**.
2. Klik file **app-release.apk** → download ke HP.
3. Buka file APK-nya → HP akan minta izin **Install from unknown sources** → izinkan → Install.

Selesai. Buka app **Volta** dari drawer.

---

## KALAU GAGAL BUILD

Copas error terakhir ke chat, kirim ke saya. 90% masalah biasanya:

- **`flutter.sdk not set in local.properties`** → normal di Codemagic, dia handle sendiri. Kalau muncul di lokal, abaikan.
- **`AAPT: error: resource mipmap/ic_launcher not found`** → jalankan sekali di lokal `flutter pub run flutter_launcher_icons`, atau minta saya generate ic_launcher.png langsung.
- **`Gradle build failed`** → biasanya versi Kotlin/Gradle. File `settings.gradle` sudah pin ke versi kompatibel.

---

## STRUKTUR PROJECT

```
volta/
├── pubspec.yaml              # dependencies
├── codemagic.yaml            # config auto-build
├── analysis_options.yaml
├── assets/
│   ├── icon.png              # launcher icon 1024×1024
│   └── icon_fg.png
├── lib/
│   ├── main.dart             # entry, splash, provider
│   ├── home_screen.dart      # layar utama
│   ├── services/
│   │   ├── battery_service.dart      # baca data baterai
│   │   └── notification_service.dart # notif colok/cabut
│   ├── theme/
│   │   └── app_theme.dart    # warna & tipografi
│   └── widgets/
│       ├── top_bar.dart
│       ├── hero_current.dart          # angka mA besar + partikel
│       ├── particle_field.dart        # animasi partikel
│       ├── stat_card.dart
│       └── footer_strip.dart
└── android/
    ├── app/
    │   ├── build.gradle
    │   └── src/main/
    │       ├── AndroidManifest.xml
    │       ├── kotlin/com/volta/app/MainActivity.kt   # baca BatteryManager
    │       └── res/values/{styles,colors}.xml
    ├── build.gradle
    ├── settings.gradle
    └── gradle/wrapper/gradle-wrapper.properties
```

## SPEC FITUR (yang sudah diimplementasi)

- Tema **off-white cream `#FAFAF7`** + **mustard `#C89B2A`** — light theme, elegan, gak silau.
- **Particle field animation** (bukan wave, bukan bundar) — titik naik dari bawah, jumlah & kecepatan mengikuti nilai mA real-time.
- Angka mA besar (96 px) dengan tween counter 400 ms.
- 6 stat cards: VOLTAGE, POWER, TEMP, LEVEL, HEALTH, CAPACITY.
- Top bar: wordmark + power source pill (USB/AC/WIRELESS/UNPLUGGED).
- Footer: technology + status word (CHARGING/DISCHARGING/FULL).
- Notifikasi hanya saat colok & cabut, auto-hilang 5 detik, no sound.
- Portrait-locked, splash 600 ms.
- 3 icon saja: lightning (bolt), plug, thermometer.

Nilai baterai dibaca real dari `BatteryManager` Android via Kotlin `MethodChannel` — **bukan simulasi**.
