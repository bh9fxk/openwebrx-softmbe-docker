#!/usr/bin/env bash
set -e

echo "=== Removing any existing Dire Wolf installation (source-built) ==="
rm -f /usr/local/bin/direwolf
rm -f /usr/local/share/man/man1/direwolf.1
rm -rf /usr/local/share/direwolf

echo "=== Removing any existing direwolf package ==="
apt-get remove -y direwolf || true
apt-get remove -y direwolf gpsd gpsd-clients libgps28 libgps30 || true

echo "=== Installing build dependencies for Dire Wolf ==="
BUILD_PACKAGES="git automake apt-utils libasound2-dev libudev-dev libgps-dev cmake pkg-config build-essential libhamlib-dev"
apt-get update
apt-get install -y --no-install-recommends \
        git automake apt-utils libasound2-dev libudev-dev libgps-dev cmake pkg-config build-essential libhamlib-dev
# Verify what version we actually got
echo "Installed libgps version:"
dpkg -l | grep libgps

echo "Available libgps files:"
ls -l /usr/lib/*/libgps.so*

DIREWOLF_VERSION="1.8.1"
DIREWOLF_SRC_DIR="/tmp/direwolf"

echo "=== Downloading Dire Wolf ${DIREWOLF_VERSION} ==="
# git clone --branch ${DIREWOLF_VERSION} --depth 1 https://github.com/wb2osz/direwolf.git "${DIREWOLF_SRC_DIR}"
git clone https://github.com/wb2osz/direwolf.git "${DIREWOLF_SRC_DIR}"
cd ${DIREWOLF_SRC_DIR}
mkdir build && cd build

echo "=== Building Dire Wolf ==="
cmake .. && make -j$(nproc)

echo "=== Installing Dire Wolf ==="
make install
ldconfig

echo "=== Checking linked libraries ==="
ldd /usr/local/bin/direwolf | grep gps

echo "=== Cleaning up ==="
rm -rf "${DIREWOLF_SRC_DIR}"

echo "=== Cleaning up packages ==="
apt-get -qq -y purge --autoremove --allow-remove-essential \
        git automake apt-utils cmake pkg-config build-essential
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
# strip lots of generic documentation that will never be read inside a docker container
rm /usr/local/share/doc/direwolf/*.pdf
# examples are pointless, too
rm -rf /usr/local/share/doc/direwolf/examples/

echo "✅ Dire Wolf ${DIREWOLF_VERSION} installed from source."
