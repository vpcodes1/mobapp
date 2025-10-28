#!/bin/bash

echo "========================================="
echo " Fitness Tracker - APK Builder"
echo "========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
echo -e "${YELLOW}[1/5]${NC} Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}[✗]${NC} Flutter is not installed!"
    echo ""
    echo "Please install Flutter first:"
    echo "https://docs.flutter.dev/get-started/install"
    exit 1
else
    echo -e "${GREEN}[✓]${NC} Flutter is installed"
    flutter --version
fi

echo ""
echo -e "${YELLOW}[2/5]${NC} Installing dependencies..."
flutter pub get
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[✓]${NC} Dependencies installed"
else
    echo -e "${RED}[✗]${NC} Failed to install dependencies"
    exit 1
fi

echo ""
echo -e "${YELLOW}[3/5]${NC} Running Flutter doctor..."
flutter doctor

echo ""
echo -e "${YELLOW}[4/5]${NC} Building APK..."
echo ""
echo "Choose build type:"
echo "1) Debug APK (fast build, for testing)"
echo "2) Release APK (optimized, smaller size)"
echo "3) Release APK with split ABI (smallest, multiple files)"
read -p "Enter choice [1-3]: " choice

case $choice in
    1)
        echo "Building DEBUG APK..."
        flutter build apk --debug
        APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
        ;;
    2)
        echo "Building RELEASE APK..."
        flutter build apk --release
        APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
        ;;
    3)
        echo "Building RELEASE APK with split ABI..."
        flutter build apk --release --split-per-abi
        APK_PATH="build/app/outputs/flutter-apk/"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}[✓]${NC} Build successful!"
    echo ""
    echo "========================================="
    echo -e "${YELLOW}[5/5]${NC} APK Files:"
    echo "========================================="
    ls -lh build/app/outputs/flutter-apk/*.apk
    echo ""
    echo "📦 APK location: $APK_PATH"
    echo ""
    echo "Next steps:"
    echo "1. Copy APK to your phone"
    echo "2. Enable 'Unknown sources' in phone settings"
    echo "3. Install the APK"
    echo ""
else
    echo -e "${RED}[✗]${NC} Build failed!"
    exit 1
fi
