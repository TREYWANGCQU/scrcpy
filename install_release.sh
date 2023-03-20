

#!/usr/bin/env bash
set -e
sudo apt install ffmpeg libsdl2-2.0-0 adb wget \
	         gcc git pkg-config meson ninja-build libsdl2-dev \
        	 libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
		 libusb-1.0-0 libusb-1.0-0-dev
BUILDDIR=build-auto
PREBUILT_SERVER_URL=https://github.com/Genymobile/scrcpy/releases/download/v2.0/scrcpy-server-v2.0
PREBUILT_SERVER_SHA256=9e241615f578cd690bb43311000debdecf6a9c50a7082b001952f18f6f21ddc2

rm scrcpy-server
echo "[scrcpy] Downloading prebuilt server..."
wget -e "https_proxy=192.168.131.110:10809"  "$PREBUILT_SERVER_URL" -O scrcpy-server
echo "[scrcpy] Verifying prebuilt server..."
echo "$PREBUILT_SERVER_SHA256  scrcpy-server" | sha256sum --check

echo "[scrcpy] Building client..."
rm -rf "$BUILDDIR"
meson setup "$BUILDDIR" --buildtype=release --strip -Db_lto=true \
    -Dprebuilt_server=scrcpy-server
cd "$BUILDDIR"
ninja 

echo "[scrcpy] Installing (sudo)..."
sudo ninja install
