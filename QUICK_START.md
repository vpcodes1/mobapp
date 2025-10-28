# ⚡ BRZI START - 5 Minuta

Ako već imaš Flutter instaliran, evo kako da pokreneš aplikaciju ZA 5 MINUTA:

## 1️⃣ Instaliraj Dependencies (1 min)

Otvori terminal u folderu projekta:

```bash
flutter pub get
```

## 2️⃣ Pokreni Emulator ili Telefon (1 min)

### OPCIJA A - Android Emulator:
```bash
# Listaj dostupne emulatore
flutter emulators

# Pokreni emulator (zameni <id> sa pravim ID-jem)
flutter emulators --launch <emulator_id>
```

### OPCIJA B - Pravi Telefon (BRŽE!):
1. Omogući "USB Debugging" na telefonu
2. Poveži USB kablom
3. Proveri: `flutter devices`

## 3️⃣ Pokreni Aplikaciju (3 min prvi put, 30s posle)

```bash
flutter run
```

Ili u VS Code: pritisni **F5**

---

## 🎮 Kontrole tokom rada:

Dok aplikacija radi, u terminalu možeš koristiti:

- `r` - Hot reload (instant refresh posle izmena)
- `R` - Hot restart (pun restart)
- `p` - Prikaži grid overlay
- `o` - Toggle platform (Android/iOS)
- `q` - Quit aplikacija

---

## 🐛 Brzi Fix za Česte Probleme:

### Problem: Gradle error pri build-u
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Problem: "No device found"
```bash
# Proveri dostupne uređaje
flutter devices

# Restartuj ADB
adb kill-server
adb start-server
flutter devices
```

### Problem: Spor build
```bash
# Build u release modu (10x brže!)
flutter run --release
```

---

## 📱 Build APK za instalaciju:

```bash
# Debug APK (brz build)
flutter build apk --debug

# Release APK (optimizovan, manji fajl)
flutter build apk --release
```

APK je u: `build/app/outputs/flutter-apk/app-release.apk`

Kopiraj na telefon i instaliraj!

---

## 🔥 Hot Reload - Instant izmene!

1. Pokreni aplikaciju: `flutter run`
2. Izmeni bilo koji Dart fajl (npr. promeni boju u `lib/main.dart`)
3. Sačuvaj fajl (Ctrl+S)
4. U terminalu upucaj `r`
5. Izmena se odmah vidi na telefonu! ⚡

---

## 🎨 Gdje šta mijenjati:

| Šta želiš da promeniš | Fajl |
|----------------------|------|
| Boje aplikacije | `lib/main.dart` (line 20-30) |
| Home ekran | `lib/screens/home_screen.dart` |
| Workout tracking | `lib/screens/workout_screen.dart` |
| Database struktura | `lib/services/database_service.dart` |
| App ikona | `android/app/src/main/res/mipmap-*/ic_launcher.png` |
| App ime | `android/app/src/main/AndroidManifest.xml` (line 11) |

---

## ✅ Prvi Test - Promeni boju:

1. Otvori `lib/main.dart`
2. Nađi liniju:
   ```dart
   seedColor: const Color(0xFF6366F1),
   ```
3. Promeni u:
   ```dart
   seedColor: Colors.red,
   ```
4. Sačuvaj (Ctrl+S)
5. U terminalu: pritisni `r`
6. Aplikacija postaje crvena! 🎨

---

**Bilo kakvi problemi?** Pogledaj pun SETUP_GUIDE.md ili javi!
