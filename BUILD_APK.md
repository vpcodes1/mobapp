# 📱 BUILD APK Vodič

Evo **3 načina** da dobiješ APK fajl:

---

## 🤖 METODA 1: Automatski Build (GitHub Actions) - NAJLAKŠE!

Već sam postavio automatski build sistem!

### Kako preuzeti APK:

1. **Idi na GitHub repozitorijum**
2. Klikni na **Actions** tab
3. Klikni na najnoviji **Build Android APK** workflow
4. Skroluj dole do **Artifacts** sekcije
5. Preuzmi:
   - `fitness-tracker-debug.apk` - za testiranje (brz build)
   - `fitness-tracker-release.apk` - za produkciju (optimizovan)

### Kako pokrenuti build ručno:

1. Idi na GitHub → **Actions** → **Build Android APK**
2. Klikni **Run workflow** → **Run workflow**
3. Sačekaj 5-10 minuta
4. Preuzmi APK iz Artifacts sekcije

---

## 💻 METODA 2: Build Lokalno (Ako imaš Flutter)

Ako si već instalirao Flutter (iz SETUP_GUIDE.md):

```bash
# 1. Idi u folder projekta
cd mobapp

# 2. Instaliraj dependencies
flutter pub get

# 3. Build DEBUG APK (brzo, za testiranje)
flutter build apk --debug

# 4. Ili build RELEASE APK (optimizovan, manji fajl)
flutter build apk --release
```

APK će biti u:
- Debug: `build/app/outputs/flutter-apk/app-debug.apk`
- Release: `build/app/outputs/flutter-apk/app-release.apk`

### Build po ABI (manji fajlovi):

```bash
# Kreira posebne APK za svaki tip procesora
flutter build apk --release --split-per-abi
```

Dobićeš 3 APK fajla:
- `app-armeabi-v7a-release.apk` - stariji telefoni (32-bit)
- `app-arm64-v8a-release.apk` - **noviji telefoni (64-bit)** ← Najverovatnije trebaš ovaj!
- `app-x86_64-release.apk` - emulatori

---

## 📦 METODA 3: Preuzmi Pre-built APK

Ako sam već build-ovao APK, biće u **GitHub Releases**:

1. Idi na: `https://github.com/tvoj-username/mobapp/releases`
2. Preuzmi najnoviji `fitness-tracker-release.apk`
3. Instaliraj na telefon

---

## 📲 Kako Instalirati APK na Telefon

### Android Telefon:

1. **Omogući instalaciju iz nepoznatih izvora:**
   - Settings → Security
   - Omogući "Unknown sources" ili "Install unknown apps"

2. **Prebaci APK na telefon:**
   - USB kablom (kopiraj fajl)
   - Ili pošalji sebi na email/WhatsApp i preuzmi

3. **Instaliraj:**
   - Otvori Files app
   - Pronađi APK fajl
   - Tap na njega → Install

4. **Pokreni aplikaciju:**
   - Traži "Fitness Tracker" u app drawer-u

---

## 🔍 Kako Proveriti koju ABI treba

```bash
# Poveži telefon USB-om i omogući USB debugging
adb shell getprop ro.product.cpu.abi
```

Output će biti:
- `arm64-v8a` → koristi `app-arm64-v8a-release.apk` (najčešće)
- `armeabi-v7a` → koristi `app-armeabi-v7a-release.apk`
- `x86_64` → koristi `app-x86_64-release.apk`

**Ako nisi siguran:** Koristi "fat" APK (bez split-per-abi) - radi na svim uređajima ali je veći.

---

## 🐛 Troubleshooting

### Problem: "App not installed"

**Rešenje:**
1. Obriši staru verziju ako postoji
2. Proveri da imaš dovoljno prostora (50MB+)
3. Pokušaj reboot telefona

### Problem: "Parse error"

**Rešenje:**
- APK je oštećen
- Preuzmi ponovo
- Ili build-uj lokalno

### Problem: "Signing error" pri build-u

**Rešenje:**
Debug APK ne treba signing. Za release APK bez signinga:

```bash
flutter build apk --release
```

(Već podešeno u projektu da koristi debug signing)

---

## 📊 Poređenje APK Tipova

| Tip | Veličina | Brzina | Kada koristiti |
|-----|----------|--------|----------------|
| **Debug** | ~40MB | Brz build | Za testiranje i development |
| **Release** | ~20MB | Spor build | Za distribuciju korisnicima |
| **Split ABI** | ~15MB | Spor build | Za objavu na Google Play |

---

## 🚀 Sledeći Koraci

Nakon što dobiješ APK:

1. **Testiraj aplikaciju na telefonu**
2. **Prijavi bugove** ako ih nađeš
3. **Predloži nove funkcionalnosti**

---

## 🔐 Za Google Play Store Objavu

Kada budeš spreman za release:

1. **Kreiraj keystore:**
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Kreiraj key.properties:**
   ```
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<putanja-do-keystore>
   ```

3. **Build signed APK:**
   ```bash
   flutter build appbundle --release
   ```

4. **Upload na Play Console**

---

**Javi mi koju metodu koristiš pa ću ti pomoći ako nešto zapne!** 😊
