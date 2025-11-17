#!/usr/bin/env bash
set -e

echo "=== Removing any existing direwolf package ==="
apt-get remove -y direwolf || true

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
    pkg-config

DIREWOLF_VERSION="1.8.1"
DIREWOLF_SRC_DIR="/tmp/direwolf-${DIREWOLF_VERSION}"

echo "=== Downloading Dire Wolf ${DIREWOLF_VERSION} ==="
git clone --branch ${DIREWOLF_VERSION} --depth 1 https://github.com/wb2osz/direwolf.git "${DIREWOLF_SRC_DIR}"
cd "${DIREWOLF_SRC_DIR}"

echo "=== Building Dire Wolf ==="
make -j$(nproc)

echo "=== Installing Dire Wolf ==="
make install
ldconfig

echo "=== Cleaning up ==="
rm -rf "${DIREWOLF_SRC_DIR}"
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "✅ Dire Wolf ${DIREWOLF_VERSION} installed from source."
