# Fitness Tracker - Android App

Kompletan Android fitness tracker aplikacija napravljena sa Flutter-om sa svim funkcionalnostima za praćenje treninga, napretka i statistike.

## Funkcionalnosti

### MVP (Minimum Viable Product)

- **Praćenje Vežbi**: Unos vežbi sa setovima, ponavljanjima i težinom
- **Dashboard**: Pregled aktivnosti i trenutnog progresa
- **Workout History**: Kompletna istorija svih treninga sa detaljima
- **Analytics**: Grafički prikaz napretka po mišićnim grupama

### Dodatne Funkcionalnosti (Za Buduće Verzije)

- Workout Plans - Predefinisani trening planovi
- Nutrition Tracking - Praćenje kalorija i makronutrijenata
- Progress Photos - Upload fotografija za praćenje vizuelnog progresa
- Social Features - Deljenje postignuća sa prijateljima
- Reminder Notifikacije - Podsećanje na treninge

## Tehnologije

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **Local Database**: SQLite (sqflite)
- **Charts**: fl_chart
- **UI**: Material Design 3

## Struktura Projekta

```
lib/
├── main.dart                 # Entry point aplikacije
├── models/                   # Data modeli
│   ├── exercise.dart
│   ├── workout.dart
│   ├── workout_exercise.dart
│   └── workout_set.dart
├── providers/                # State management
│   └── workout_provider.dart
├── screens/                  # UI ekrani
│   ├── home_screen.dart     # Dashboard
│   ├── workout_screen.dart  # Aktivni trening
│   ├── history_screen.dart  # Istorija treninga
│   ├── analytics_screen.dart # Statistika
│   └── profile_screen.dart  # Profil i podešavanja
└── services/                # Business logika
    └── database_service.dart # SQLite operacije
```

## Instalacija i Pokretanje

### Preduslov

1. Instalirajte [Flutter SDK](https://flutter.dev/docs/get-started/install) (verzija 3.0 ili novija)
2. Instalirajte [Android Studio](https://developer.android.com/studio) sa Android SDK
3. Podesite Android emulator ili povežite fizički uređaj

### Koraci za Pokretanje

1. Klonirajte repozitorijum:
```bash
git clone <repository-url>
cd mobapp
```

2. Instalirajte dependencies:
```bash
flutter pub get
```

3. Proverite da li su uređaji dostupni:
```bash
flutter devices
```

4. Pokrenite aplikaciju:
```bash
flutter run
```

Ili za release verziju:
```bash
flutter run --release
```

### Build APK

Za kreiranje APK fajla:
```bash
flutter build apk --release
```

APK će biti sačuvan u: `build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (za Google Play Store)

```bash
flutter build appbundle --release
```

## Baza Podataka

Aplikacija koristi SQLite za lokalno skladištenje podataka:

- **exercises**: Lista svih dostupnih vežbi
- **workouts**: Pojedinačni treninzi
- **workout_exercises**: Veze između treninga i vežbi
- **workout_sets**: Pojedinačni setovi sa brojem ponavljanja i težinom

Baza se automatski kreira pri prvom pokretanju sa 25+ unapred definisanih vežbi.

## Ekrani

### 1. Home Screen (Dashboard)
- Pregled statistike (ukupni treninzi, treninzi ove nedelje, ukupni setovi)
- Quick start dugme za novi trening
- Poslednji treninzi

### 2. Workout Screen
- Aktivni trening sa timerom
- Dodavanje vežbi iz liste
- Unos setova (ponavljanja i težina)
- Završi ili otkaži trening

### 3. History Screen
- Lista svih prošlih treninga
- Detalji pojedinačnog treninga
- Filtriranje po datumu

### 4. Analytics Screen
- Grafici učestalosti treninga (zadnjih 7 dana)
- Distribucija mišićnih grupa (pie chart)
- Progress insights

### 5. Profile Screen
- Korisnički profil
- Podešavanja aplikacije (tema, jezik, jedinice)
- Subscription opcije (Free/Basic/Pro/Elite)

## Poslovni Model

### Subscription Tiers

1. **FREE** - Trenutno dostupno
   - Osnovno praćenje treninga
   - Ograničena istorija

2. **Basic** - $5/mesečno
   - Unlimited workout tracking
   - Puna istorija

3. **Pro** - $15/mesečno
   - Sve Basic funkcionalnosti
   - AI preporuke
   - Napredne analytics
   - Custom workout planovi

4. **Elite** - $25/mesečno
   - Sve Pro funkcionalnosti
   - Pristup online treneru
   - Nutrition tracking
   - Progress photos

## Sledeći Koraci

1. **Backend Integration**: Implementacija cloud sync-a
2. **Authentication**: Dodavanje korisničkih naloga
3. **Social Features**: Deljenje i zajednica
4. **Workout Plans**: Predefinisani programi treninga
5. **Nutrition Tracking**: Kalkulator kalorija
6. **AI Coaching**: Personalizovane preporuke
7. **iOS Version**: Port na iOS platformu

## Testiranje

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test
```

## Deployment

### Google Play Store

1. Kreirati keystore za potpisivanje aplikacije
2. Build release app bundle
3. Upload na Play Console
4. Popuniti store listing (naziv, opis, slike)
5. Submit za review

## Kontribucija

Za doprinose projektu:
1. Fork repozitorijum
2. Kreirajte feature branch
3. Commit izmene
4. Push i kreirajte Pull Request

## Licenca

MIT License

## Kontakt

Za pitanja i sugestije, kontaktirajte razvojni tim.

---

**Verzija**: 1.0.0
**Poslednji Update**: 2025
