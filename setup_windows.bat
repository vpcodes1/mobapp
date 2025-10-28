@echo off
echo ========================================
echo Flutter Fitness Tracker - Setup Script
echo ========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running with administrator privileges
) else (
    echo [!] Warning: Not running as administrator. Some steps may fail.
    echo Right-click and select "Run as administrator" for best results.
    pause
)

echo.
echo Step 1: Checking if Git is installed...
git --version >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Git is installed
) else (
    echo [X] Git is NOT installed
    echo Please install Git from: https://git-scm.com/download/win
    echo Then run this script again.
    pause
    exit /b 1
)

echo.
echo Step 2: Checking if Flutter is installed...
flutter --version >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Flutter is already installed
    flutter --version
) else (
    echo [X] Flutter is NOT installed
    echo.
    echo Please follow these steps:
    echo 1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/windows
    echo 2. Extract to C:\src\flutter
    echo 3. Add C:\src\flutter\bin to your PATH
    echo 4. Run this script again
    pause
    exit /b 1
)

echo.
echo Step 3: Running Flutter Doctor...
flutter doctor

echo.
echo Step 4: Accepting Android Licenses...
flutter doctor --android-licenses

echo.
echo Step 5: Installing Flutter dependencies...
cd /d "%~dp0"
flutter pub get

echo.
echo Step 6: Checking for connected devices...
flutter devices

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next Steps:
echo 1. Open Android Studio and start an emulator
echo 2. Run: flutter run
echo.
echo Or use VS Code:
echo 1. Open this folder in VS Code
echo 2. Press F5 to run
echo.

pause
