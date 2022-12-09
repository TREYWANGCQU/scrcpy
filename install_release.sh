

#!/usr/bin/env bash
set -e
sudo apt install ffmpeg libsdl2-2.0-0 adb wget \
	         gcc git pkg-config meson ninja-build libsdl2-dev \
        	 libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
		 libusb-1.0-0 libusb-1.0-0-dev
BUILDDIR=build-auto
PREBUILT_SERVER_URL=https://github.com/Genymobile/scrcpy/releases/download/v1.24/scrcpy-server-v1.24
PREBUILT_SERVER_SHA256=ae74a81ea79c0dc7250e586627c278c0a9a8c5de46c9fb5c38c167fb1a36f056

rm scrcpy-server
echo "[scrcpy] Downloading prebuilt server..."
wget -e "https_proxy=172.18.80.1:10809"  "$PREBUILT_SERVER_URL" -O scrcpy-server
echo "[scrcpy] Verifying prebuilt server..."
echo "$PREBUILT_SERVER_SHA256  scrcpy-server" | sha256sum --check

echo "[scrcpy] Building client..."
rm -rf "$BUILDDIR"
meson "$BUILDDIR" --buildtype=release --strip -Db_lto=true \
    -Dprebuilt_server=scrcpy-server
cd "$BUILDDIR"
ninja 

echo "[scrcpy] Installing (sudo)..."
sudo ninja install
