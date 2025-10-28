# 📱 Flutter Android App - Setup Vodič za VS Code

## Šta ćeš instalirati:
1. Flutter SDK (~1GB)
2. VS Code (~100MB)
3. Android Studio (~3GB) - samo za Android SDK
4. Java JDK

---

## 🪟 WINDOWS INSTALACIJA

### KORAK 1: Proveri Sistem Zahteve

**Minimalni zahtevi:**
- Windows 10 ili noviji (64-bit)
- 10 GB slobodnog prostora
- Git instaliran

**Proveri da li imaš Git:**
1. Otvori Command Prompt (Win + R, ukucaj `cmd`)
2. Upucaj: `git --version`
3. Ako nemaš, preuzmi sa: https://git-scm.com/download/win

---

### KORAK 2: Instaliraj Flutter SDK

**Metoda A - Preuzimanje (PREPORUČENO):**

1. **Preuzmi Flutter:**
   - Idi na: https://docs.flutter.dev/get-started/install/windows
   - Klikni na dugme "Download Flutter SDK"
   - Ili direktan link: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.0-stable.zip

2. **Ekstraktuj Flutter:**
   - Desni klik na preuzeti .zip fajl
   - "Extract All..."
   - Ekstraktuj u: `C:\src\flutter` (ili bilo gde BEZ razmaka u putanji)
   - **VAŽNO:** NEMOJ u `C:\Program Files\` jer ima razmake!

3. **Dodaj Flutter u PATH:**
   - Pritisni `Win + R`
   - Upucaj: `sysdm.cpl` i pritisni Enter
   - Idi na tab **Advanced**
   - Klikni **Environment Variables**
   - U "User variables" delu, pronađi **Path**
   - Klikni **Edit**
   - Klikni **New**
   - Dodaj: `C:\src\flutter\bin`
   - Klikni **OK** na svim prozorima
   - **ZATVORI SVE Command Prompt prozore i otvori novi**

4. **Proveri instalaciju:**
   ```cmd
   flutter --version
   ```
   Trebalo bi da vidiš verziju Flutter-a.

**Metoda B - Git Clone:**

```cmd
cd C:\
mkdir src
cd src
git clone https://github.com/flutter/flutter.git -b stable
```

Zatim dodaj `C:\src\flutter\bin` u PATH kao gore.

---

### KORAK 3: Instaliraj VS Code

1. **Preuzmi VS Code:**
   - Idi na: https://code.visualstudio.com/
   - Klikni **Download for Windows**

2. **Instaliraj:**
   - Pokreni instalaciju
   - **VAŽNO:** Štikliraj opciju "Add to PATH"
   - Završi instalaciju

3. **Instaliraj Flutter Extension:**
   - Otvori VS Code
   - Pritisni `Ctrl + Shift + X` (otvara Extensions)
   - Pretraži: **Flutter**
   - Instaliraj "Flutter" extension (by Dart Code)
   - To će automatski instalirati i "Dart" extension

4. **Verifikuj:**
   - Pritisni `Ctrl + Shift + P`
   - Upucaj: `Flutter: Run Flutter Doctor`
   - Pročitaj rezultate

---

### KORAK 4: Instaliraj Android Studio (za Android SDK)

**Zašto?** Flutter treba Android SDK da build-uje Android aplikacije.

1. **Preuzmi Android Studio:**
   - https://developer.android.com/studio
   - Preuzmi latest verziju

2. **Instaliraj:**
   - Pokreni installer
   - Izaberi "Standard" installation
   - Prihvati sve default opcije
   - Sačekaj da preuzme SDK (može trajati 10-30 min)

3. **Otvori Android Studio:**
   - First run će pokrenuti setup wizard
   - Izaberi "Standard" setup
   - Izaberi temu (bilo koja)
   - Finish - sačekaj da preuzme komponente

4. **Proveri SDK:**
   - U Android Studio, klikni **More Actions**
   - Izaberi **SDK Manager**
   - Proveri da je štiklirano:
     - ✅ Android SDK Platform (latest)
     - ✅ Android SDK Build-Tools
     - ✅ Android SDK Platform-Tools
     - ✅ Android SDK Command-line Tools

5. **Prihvati Android Licenses:**
   ```cmd
   flutter doctor --android-licenses
   ```
   - Upucaj `y` za sve

---

### KORAK 5: Kreiraj Android Emulator (Virtuelni Telefon)

**U Android Studio:**

1. Klikni **More Actions** → **Virtual Device Manager**
2. Klikni **Create Device**
3. Izaberi telefon (npr. **Pixel 4** ili **Pixel 6**)
4. Klikni **Next**
5. Preuzmi system image (npr. **Android 13 (Tiramisu)** - API 33)
6. Klikni **Next**
7. Ostavi default podešavanja
8. **Finish**

**Test Emulatora:**
- Klikni ▶️ dugme pored emulatora
- Trebalo bi da se pokrene virtuelni telefon (može trajati 1-2 min prvi put)

---

### KORAK 6: Proveri da sve radi

```cmd
flutter doctor -v
```

**Šta bi trebalo da vidiš:**

```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Windows Version (Installed version of Windows is 10+)
[✓] Android toolchain - develop for Android devices (Android SDK version XX)
[✓] Chrome - develop for the web
[✓] Visual Studio Code (version XX)
[✓] Android Studio (version XXXX)
[✓] Connected device (X available)
[✓] Network resources
```

**Ako vidiš [!] ili [✗]:**
- Prati instrukcije koje `flutter doctor` ispisuje
- Najčešće treba samo pokrenuti `flutter doctor --android-licenses`

---

### KORAK 7: Otvori i Pokreni Projekat

1. **Otvori VS Code**

2. **Otvori folder:**
   - `File` → `Open Folder`
   - Pronađi i izaberi folder `mobapp`

3. **Instaliraj dependencies:**
   - Otvori Terminal u VS Code (`Ctrl + `` ` ``)
   - Upucaj:
   ```bash
   flutter pub get
   ```
   - Sačekaj da preuzme sve pakete

4. **Pokreni emulator:**
   - U Android Studio, pokreni emulator (▶️ dugme)
   - Ili iz VS Code terminala:
   ```bash
   flutter emulators
   flutter emulators --launch <id_emulatora>
   ```

5. **Pokreni aplikaciju:**

   **Metoda A - Iz VS Code:**
   - Pritisni `F5`
   - Ili: `Run` → `Start Debugging`

   **Metoda B - Terminal:**
   ```bash
   flutter run
   ```

6. **Sačekaj:**
   - Prvi build može trajati 5-10 minuta
   - Sledeći build-ovi su brži (30 sekundi)

---

## 🎉 GOTOVO!

Aplikacija bi sada trebalo da radi na emulatoru!

### Korisni Prečice u VS Code:

- `F5` - Pokreni aplikaciju
- `Shift + F5` - Stop aplikacija
- `Ctrl + F5` - Pokreni bez debugginga (brže)
- `r` u terminalu - Hot reload (brze izmene)
- `R` u terminalu - Hot restart (pun restart)

---

## 🔧 TROUBLESHOOTING

### Problem: "Flutter command not found"
**Rešenje:**
- Nisi dodao Flutter u PATH
- Zatvori i ponovo otvori Command Prompt
- Proveri PATH: `echo %PATH%`

### Problem: "Android licenses not accepted"
**Rešenje:**
```cmd
flutter doctor --android-licenses
```
Upucaj `y` za sve.

### Problem: "No devices found"
**Rešenje:**
- Pokreni Android emulator prvo
- Proveri: `flutter devices`

### Problem: "Gradle build failed"
**Rešenje:**
1. Obriši folder: `mobapp\android\.gradle`
2. Obriši folder: `mobapp\build`
3. Ponovo pokreni: `flutter pub get` pa `flutter run`

### Problem: "SDK location not found"
**Rešenje:**
Kreiraj fajl `android/local.properties`:
```properties
sdk.dir=C:\\Users\\TVOJE_IME\\AppData\\Local\\Android\\Sdk
flutter.sdk=C:\\src\\flutter
```

### Problem: Sporo pokretanje
**Rešenje:**
- Smanji RAM emulatora u AVD Manager
- Koristi "Cold Boot" umesto "Quick Boot"
- Ili testiraj na pravom telefonu

---

## 📱 Testiranje na PRAVOM TELEFONU (Brže od emulatora!)

1. **Na telefonu:**
   - Idi u Settings → About Phone
   - Tap-uj 7 puta "Build Number"
   - Vrati se → Developer Options
   - Omogući "USB Debugging"

2. **Poveži USB kablom**

3. **Proveri:**
   ```cmd
   flutter devices
   ```

4. **Pokreni:**
   ```cmd
   flutter run
   ```

Biće MNOGO brže nego emulator!

---

## 📚 Korisni Linkovi

- Flutter Docs: https://docs.flutter.dev/
- Flutter YouTube: https://www.youtube.com/@flutterdev
- Flutter Community: https://flutter.dev/community

---

**Pitanja?** Javi ako nešto ne radi ili treba pomoć!
