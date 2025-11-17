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
apt-get update
apt-get install -y \
    git \
    gcc \
    make \
    libasound2-dev \
    libudev-dev \
    libgps-dev \
    cmake \
    pkg-config \
    build-essential \
    libhamlib-dev

# Verify what version we actually got
echo "Installed libgps version:"
dpkg -l | grep libgps

echo "Available libgps files:"
ls -l /usr/lib/*/libgps.so*

DIREWOLF_VERSION="1.8.1"
DIREWOLF_SRC_DIR="/tmp/direwolf-${DIREWOLF_VERSION}"

echo "=== Downloading Dire Wolf ${DIREWOLF_VERSION} ==="
git clone --branch ${DIREWOLF_VERSION} --depth 1 https://github.com/wb2osz/direwolf.git "${DIREWOLF_SRC_DIR}"
cd ${DIREWOLF_SRC_DIR}
mkdir build && cd build

echo "=== Building Dire Wolf ==="
cmake .. && make -j$(nproc)

echo "=== Installing Dire Wolf ==="
make install
ldconfig

echo "=== Checking linked libraries ==="
ldd /usr/local/bin/direwolf | grep gps

# Optional: force-recreate standard symlink if missing
LIBGPS_SO=$(find /usr/lib -name "libgps.so.*" -type f | head -1)
if [ -n "$LIBGPS_SO" ]; then
    LIB_DIR=$(dirname "$LIBGPS_SO")
    ln -sf "$LIBGPS_SO" "${LIB_DIR}/libgps.so"
    echo "Ensured libgps.so symlink exists."
fi

echo "=== Cleaning up ==="
rm -rf "${DIREWOLF_SRC_DIR}"
apt-get autoremove -y
apt-get -qq -y purge --autoremove --allow-remove-essential \
    git \
    gcc \
    make \
    libasound2-dev \
    libudev-dev \
    libgps-dev \
    cmake \
    pkg-config \
    build-essential \
    libhamlib-dev
apt-get clean
rm -rf /var/lib/apt/lists/*
# strip lots of generic documentation that will never be read inside a docker container
rm /usr/local/share/doc/direwolf/*.pdf
# examples are pointless, too
rm -rf /usr/local/share/doc/direwolf/examples/

echo "✅ Dire Wolf ${DIREWOLF_VERSION} installed from source."
