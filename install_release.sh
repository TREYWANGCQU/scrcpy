#!/usr/bin/env bash
set -e
sudo apt install ffmpeg libsdl2-2.0-0 adb wget \
	         gcc git pkg-config meson ninja-build libsdl2-dev \
        	 libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
		 libusb-1.0-0 libusb-1.0-0-dev
BUILDDIR=build-auto
PREBUILT_SERVER_URL=https://github.com/Genymobile/scrcpy/releases/download/v1.20/scrcpy-server-v1.20
PREBUILT_SERVER_SHA256=b20aee4951f99b060c4a44000ba94de973f9604758ef62beb253b371aad3df34

echo "[scrcpy] Downloading prebuilt server..."
wget -e "https_proxy=192.168.50.226:41091"  "$PREBUILT_SERVER_URL" -O scrcpy-server
echo "[scrcpy] Verifying prebuilt server..."
echo "$PREBUILT_SERVER_SHA256  scrcpy-server" | sha256sum --check

echo "[scrcpy] Building client..."
rm -rf "$BUILDDIR"
meson "$BUILDDIR" --buildtype release --strip -Db_lto=true \
    -Dprebuilt_server=scrcpy-server
cd "$BUILDDIR"
ninja 

echo "[scrcpy] Installing (sudo)..."
sudo ninja install
