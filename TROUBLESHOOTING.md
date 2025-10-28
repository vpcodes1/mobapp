# 🔧 Troubleshooting Guide

Najčešći problemi i njihova rešenja:

---

## ❌ "flutter: command not found" ili "flutter is not recognized"

**Uzrok:** Flutter nije u PATH-u.

**Rešenje:**

### Windows:
1. Pritisni `Win + R`
2. Upucaj: `sysdm.cpl` → Enter
3. Tab "Advanced" → "Environment Variables"
4. U "User variables" nađi "Path" → Edit
5. Dodaj: `C:\src\flutter\bin` (ili gde god je tvoj Flutter)
6. OK na svemu
7. **ZATVORI I PONOVO OTVORI Command Prompt**
8. Test: `flutter --version`

### Mac/Linux:
```bash
# Dodaj u ~/.bashrc ili ~/.zshrc
export PATH="$PATH:/path/to/flutter/bin"

# Reload
source ~/.bashrc
```

---

## ❌ "Android licenses not accepted"

**Rešenje:**
```bash
flutter doctor --android-licenses
```
Pritisni `y` za sve.

Ako ne radi:
1. Proveri da li imaš JDK instaliran
2. Instaliraj: https://www.oracle.com/java/technologies/downloads/
3. Ponovo pokreni komandu

---

## ❌ "No devices found" / "No connected devices"

**Uzrok:** Nijedan emulator ili telefon nije povezan.

**Rešenje:**

### Za Emulator:
```bash
# Listaj emulatore
flutter emulators

# Pokreni emulator
flutter emulators --launch <emulator_name>

# Proveri ponovo
flutter devices
```

### Za Pravi Telefon:
1. **Na telefonu:**
   - Settings → About Phone
   - Tap 7x na "Build Number"
   - Settings → Developer Options
   - Omogući "USB Debugging"

2. **Na računaru:**
   ```bash
   # Restartuj ADB
   adb kill-server
   adb start-server

   # Proveri uređaje
   adb devices
   flutter devices
   ```

3. **Na telefonu se pojavi popup** - Prihvati USB debugging

---

## ❌ "Gradle build failed"

**Najčešće rešenje:**

```bash
cd android
./gradlew clean   # (ili gradlew.bat clean na Windowsu)
cd ..
flutter clean
flutter pub get
flutter run
```

**Ako i dalje ne radi:**

1. **Obriši cache:**
   ```bash
   # Windows
   rmdir /s /q build
   rmdir /s /q android\.gradle

   # Mac/Linux
   rm -rf build
   rm -rf android/.gradle
   ```

2. **Ponovo build:**
   ```bash
   flutter pub get
   flutter run
   ```

---

## ❌ "SDK location not found"

**Rešenje:** Kreiraj fajl `android/local.properties`:

```properties
sdk.dir=C:\\Users\\TVOJE_IME\\AppData\\Local\\Android\\Sdk
flutter.sdk=C:\\src\\flutter
```

Zameni putanje sa svojim pravim putanjama!

**Kako naći SDK putanju:**
```bash
# Windows
echo %ANDROID_HOME%

# Mac/Linux
echo $ANDROID_HOME
```

Ili u Android Studio: **More Actions** → **SDK Manager** → gornja putanja

---

## ❌ "Could not download gradle-X.X-all.zip"

**Uzrok:** Firewall ili loša internet konekcija.

**Rešenje:**

1. **Ručno preuzmi Gradle:**
   - Otvori: https://services.gradle.org/distributions/
   - Preuzmi verziju iz error poruke (npr. `gradle-7.5-all.zip`)

2. **Kopiraj u cache:**
   - Windows: `C:\Users\TVOJE_IME\.gradle\wrapper\dists\`
   - Mac/Linux: `~/.gradle/wrapper/dists/`

3. **Ekstraktuj zip** u taj folder

4. **Ponovo pokreni build**

---

## ❌ "Execution failed for task ':app:processDebugResources'"

**Uzrok:** Greška u Android resource fajlovima.

**Rešenje:**

1. Proveri `android/app/src/main/res/` foldere
2. Obriši sve `values-*` foldere osim `values`
3. Clean build:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

---

## ❌ "Error: Out of memory"

**Uzrok:** Gradle treba više memorije.

**Rešenje:** Izmeni `android/gradle.properties`:

```properties
org.gradle.jvmargs=-Xmx2048M -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
```

Povećaj `-Xmx2048M` na `-Xmx4096M` ako imaš RAM.

---

## ❌ "Emulator: WARNING: EmulatorService.cpp" ili sporo radi

**Rešenje:**

1. **Omogući Hardware Acceleration:**
   - Windows: Instaliraj Intel HAXM
   - Linux: Koristi KVM
   - Mac: Hypervisor je već uključen

2. **Smanji RAM emulatora:**
   - AVD Manager → Edit emulator
   - Smanji RAM sa 2GB na 1GB ili 512MB

3. **Koristi Cold Boot:**
   - AVD Manager → Edit → Show Advanced
   - Boot option: "Cold Boot"

---

## ❌ "Plugin project :package_name not found"

**Rešenje:**

```bash
# Ovo rešava 90% plugin problema
flutter clean
flutter pub cache repair
flutter pub get
```

---

## ❌ Aplikacija se pokrene ali odmah crashuje

**Debug postupak:**

1. **Pokreni sa verbose logovima:**
   ```bash
   flutter run -v
   ```

2. **Proveri logove:**
   ```bash
   flutter logs
   ```
   ili
   ```bash
   adb logcat
   ```

3. **Najčešći uzroci:**
   - Greška u bazi podataka (proveri `lib/services/database_service.dart`)
   - Nedostaju permissions u `AndroidManifest.xml`
   - Plugin nije inicijalizovan

---

## ❌ "Could not find or load main class org.gradle.wrapper.GradleWrapperMain"

**Rešenje:**

```bash
cd android
# Windows:
gradlew.bat wrapper --gradle-version=7.5

# Mac/Linux:
./gradlew wrapper --gradle-version=7.5

cd ..
flutter clean
flutter run
```

---

## ❌ Hot Reload ne radi / Izmene se ne prikazuju

**Rešenje:**

1. **Proveri da imaš `const` constructor-e gdje treba:**
   ```dart
   // Umesto:
   MyWidget()

   // Koristi:
   const MyWidget()
   ```

2. **Full restart umesto reload:**
   - Pritisni `R` (veliko) umesto `r`

3. **Ponovo pokreni aplikaciju:**
   ```bash
   # Stop
   q

   # Pokreni ponovo
   flutter run
   ```

---

## ❌ "Unhandled Exception: MissingPluginException"

**Rešenje:**

```bash
flutter clean
rm -rf build   # ili rmdir /s /q build na Windowsu
flutter pub get
flutter run
```

Ako ne radi:
1. Restartuj IDE (VS Code / Android Studio)
2. Restartuj ADB: `adb kill-server && adb start-server`
3. Ponovo pokreni

---

## ❌ "Waiting for another flutter command to release the startup lock"

**Uzrok:** Drugi Flutter proces je zaključao fajl.

**Rešenje:**

```bash
# Obriši lock fajl
# Windows:
del %USERPROFILE%\.flutter\bin\cache\lockfile

# Mac/Linux:
rm ~/.flutter/bin/cache/lockfile
```

Ili:
```bash
# Ubij sve Flutter procese
# Windows Task Manager: End flutter.exe i dart.exe
# Mac/Linux:
killall flutter
killall dart
```

---

## 🆘 Ultimativno Rešenje (Nuclear Option)

Ako ništa ne pomaže:

```bash
# 1. Obriši sve cache
flutter clean
flutter pub cache clean

# 2. Obriši build foldere
rm -rf build
rm -rf android/.gradle
rm -rf android/app/build

# 3. Ponovo instaliraj dependencies
flutter pub get

# 4. Repair cache
flutter pub cache repair

# 5. Ponovo pokreni
flutter run
```

---

## 📞 Još uvijek ne radi?

1. **Proveri Flutter verziju:**
   ```bash
   flutter --version
   ```
   Preporučeno: Flutter 3.0 ili novije

2. **Upgrade Flutter:**
   ```bash
   flutter upgrade
   ```

3. **Pokreni doctor:**
   ```bash
   flutter doctor -v
   ```
   Kopiraj output i javi problema.

4. **Proveri GitHub Issues:**
   - https://github.com/flutter/flutter/issues

5. **Stack Overflow:**
   - Pretraži svoju error poruku
   - https://stackoverflow.com/questions/tagged/flutter

---

**Šalje mi error poruku i pomoći ću ti direktno!** 😊
