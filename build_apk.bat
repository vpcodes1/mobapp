@echo off
echo =========================================
echo  Fitness Tracker - APK Builder
echo =========================================
echo.

REM Check if Flutter is installed
echo [1/5] Checking Flutter installation...
flutter --version >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Flutter is installed
    flutter --version
) else (
    echo [X] Flutter is NOT installed!
    echo.
    echo Please install Flutter first:
    echo https://docs.flutter.dev/get-started/install
    pause
    exit /b 1
)

echo.
echo [2/5] Installing dependencies...
flutter pub get
if %errorLevel% == 0 (
    echo [OK] Dependencies installed
) else (
    echo [X] Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo [3/5] Running Flutter doctor...
flutter doctor

echo.
echo [4/5] Building APK...
echo.
echo Choose build type:
echo 1) Debug APK (fast build, for testing)
echo 2) Release APK (optimized, smaller size)
echo 3) Release APK with split ABI (smallest, multiple files)
set /p choice="Enter choice [1-3]: "

if "%choice%"=="1" (
    echo Building DEBUG APK...
    flutter build apk --debug
    set APK_PATH=build\app\outputs\flutter-apk\app-debug.apk
) else if "%choice%"=="2" (
    echo Building RELEASE APK...
    flutter build apk --release
    set APK_PATH=build\app\outputs\flutter-apk\app-release.apk
) else if "%choice%"=="3" (
    echo Building RELEASE APK with split ABI...
    flutter build apk --release --split-per-abi
    set APK_PATH=build\app\outputs\flutter-apk\
) else (
    echo Invalid choice
    pause
    exit /b 1
)

if %errorLevel% == 0 (
    echo.
    echo [OK] Build successful!
    echo.
    echo =========================================
    echo [5/5] APK Files:
    echo =========================================
    dir /b build\app\outputs\flutter-apk\*.apk
    echo.
    echo APK location: %APK_PATH%
    echo.
    echo Next steps:
    echo 1. Copy APK to your phone
    echo 2. Enable 'Unknown sources' in phone settings
    echo 3. Install the APK
    echo.
) else (
    echo [X] Build failed!
    pause
    exit /b 1
)

pause
