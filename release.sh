# Đường dẫn thư mục dự án hiện tại
CURRENT_DIRECTORY=$(pwd)

# Tên thư mục chứa dự án Flutter
FLUTTER_PROJECT_FOLDER=$(basename "$CURRENT_DIRECTORY")

# Chuyển đến thư mục dự án Flutter
cd "$CURRENT_DIRECTORY" || exit

# Kiểm tra và tải các dependencies
flutter clean
flutter pub get

# Build ứng dụng Flutter
flutter build apk --release

# Di chuyển tệp APK đã build vào một thư mục chỉ định
APK_OUTPUT_DIR="/Users/quyetnv/Documents/ReleaseApp/"
mkdir -p "$APK_OUTPUT_DIR"
mv "$CURRENT_DIRECTORY/build/app/outputs/flutter-apk/app-release.apk" "$APK_OUTPUT_DIR/$FLUTTER_PROJECT_FOLDER.apk"

echo "Quá trình build đã hoàn thành. Tệp $FLUTTER_PROJECT_FOLDER.apk được lưu tại: $APK_OUTPUT_DIR"

cd "$APK_OUTPUT_DIR"
open .