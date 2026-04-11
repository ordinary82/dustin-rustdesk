#!/bin/bash
# Generate all RustDesk icon assets from dustin branding SVGs
set -e

PROJ="/Volumes/NVMe Stack/Cool Users/dustin-mini/Documents/GitHub/dustin-rustdesk"
BRAND="$PROJ/branding"
ICON_DARK="$BRAND/icon-dark.svg"   # purple circle, white d. (for light backgrounds)
ICON_LIGHT="$BRAND/icon-light.svg" # white circle, purple d. (for dark backgrounds)
LOGO="$BRAND/../../Dropbox (Personal)/dustin.com.au/Branding/SVG/ds-logo.svg"
LOGO_REV="$BRAND/../../Dropbox (Personal)/dustin.com.au/Branding/SVG/dustin-logo_rev.svg"

echo "=== Generating PNG icons from SVG ==="

# Main app icons (use dark variant - purple circle)
for size in 1024 512 256 192 144 128 120 96 87 80 76 72 64 60 58 48 40 32 29 20 16; do
    convert -background none "$ICON_DARK" -resize ${size}x${size} "$BRAND/icon-${size}.png"
    echo "  icon-${size}.png"
done

# Tray icons for macOS (need to be monochrome-ish or simple)
# mac-tray-dark = icon on dark menu bar (use light variant)
convert -background none "$ICON_LIGHT" -resize 60x60 "$BRAND/mac-tray-dark-x2.png"
# mac-tray-light = icon on light menu bar (use dark variant)
convert -background none "$ICON_DARK" -resize 48x48 "$BRAND/mac-tray-light-x2.png"

echo "=== Replacing res/ icons ==="
cp "$BRAND/icon-1024.png" "$PROJ/res/icon.png"
cp "$BRAND/icon-1024.png" "$PROJ/res/mac-icon.png"
cp "$BRAND/icon-128.png" "$PROJ/res/128x128.png"
cp "$BRAND/icon-256.png" "$PROJ/res/128x128@2x.png"
cp "$BRAND/icon-64.png" "$PROJ/res/64x64.png"
cp "$BRAND/icon-32.png" "$PROJ/res/32x32.png"
cp "$BRAND/mac-tray-light-x2.png" "$PROJ/res/mac-tray-light-x2.png"
cp "$BRAND/mac-tray-dark-x2.png" "$PROJ/res/mac-tray-dark-x2.png"

echo "=== Generating Windows ICO files ==="
convert "$BRAND/icon-16.png" "$BRAND/icon-32.png" "$BRAND/icon-48.png" "$BRAND/icon-64.png" "$BRAND/icon-128.png" "$BRAND/icon-256.png" "$PROJ/res/icon.ico"
convert "$BRAND/icon-32.png" "$PROJ/res/tray-icon.ico"

echo "=== Replacing Flutter assets ==="
# Flutter icon SVG
cp "$ICON_DARK" "$PROJ/flutter/assets/icon.svg"

# Flutter Windows ICO
cp "$PROJ/res/icon.ico" "$PROJ/flutter/windows/runner/resources/app_icon.ico"

# Flutter iOS icons (no alpha/transparency allowed - use white background)
IOS_ICONS="$PROJ/flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset"
for pair in "1024:Icon-App-1024x1024@1x" "20:Icon-App-20x20@1x" "40:Icon-App-20x20@2x" "60:Icon-App-20x20@3x" "29:Icon-App-29x29@1x" "58:Icon-App-29x29@2x" "87:Icon-App-29x29@3x" "40:Icon-App-40x40@1x" "80:Icon-App-40x40@2x" "120:Icon-App-40x40@3x" "120:Icon-App-60x60@2x" "180:Icon-App-60x60@3x" "76:Icon-App-76x76@1x" "152:Icon-App-76x76@2x" "167:Icon-App-83.5x83.5@2x"; do
    size="${pair%%:*}"
    name="${pair#*:}"
    convert -background white "$ICON_DARK" -resize ${size}x${size} -flatten "$IOS_ICONS/${name}.png"
    echo "  iOS: ${name}.png (${size}x${size})"
done

# Flutter macOS ICNS
echo "=== Generating macOS ICNS ==="
ICONSET="$BRAND/AppIcon.iconset"
mkdir -p "$ICONSET"
convert -background none "$ICON_DARK" -resize 16x16 "$ICONSET/icon_16x16.png"
convert -background none "$ICON_DARK" -resize 32x32 "$ICONSET/icon_16x16@2x.png"
convert -background none "$ICON_DARK" -resize 32x32 "$ICONSET/icon_32x32.png"
convert -background none "$ICON_DARK" -resize 64x64 "$ICONSET/icon_32x32@2x.png"
convert -background none "$ICON_DARK" -resize 128x128 "$ICONSET/icon_128x128.png"
convert -background none "$ICON_DARK" -resize 256x256 "$ICONSET/icon_128x128@2x.png"
convert -background none "$ICON_DARK" -resize 256x256 "$ICONSET/icon_256x256.png"
convert -background none "$ICON_DARK" -resize 512x512 "$ICONSET/icon_256x256@2x.png"
convert -background none "$ICON_DARK" -resize 512x512 "$ICONSET/icon_512x512.png"
convert -background none "$ICON_DARK" -resize 1024x1024 "$ICONSET/icon_512x512@2x.png"
iconutil -c icns "$ICONSET" -o "$PROJ/flutter/macos/Runner/AppIcon.icns"
echo "  AppIcon.icns generated"

# SVG logos in res/
echo "=== Replacing SVG logos ==="
cp "$ICON_DARK" "$PROJ/res/logo.svg"
cp "$ICON_DARK" "$PROJ/res/scalable.svg"

# Fastlane icon
cp "$BRAND/icon-256.png" "$PROJ/fastlane/metadata/android/en-US/images/icon.png"

echo ""
echo "=== Done! All icons replaced with dustin branding ==="
