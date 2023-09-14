#!/bin/bash
set -euxo pipefail
export MAKEFLAGS="-j12"

#BUILD_PACKAGES="curl gnupg1 git-core debhelper cmake libprotobuf-dev protobuf-compiler libcodecserver-dev"
BUILD_PACKAGES="git build-essential debhelper cmake libprotobuf-dev protobuf-compiler libprotobuf23 libcodecserver-dev"

apt-get update
#apt install -y curl gnupg1
#curl https://repo.openwebrx.de/debian/key.gpg.txt | apt-key add
#echo "deb https://repo.openwebrx.de/debian/ experimental main" > /etc/apt/sources.list.d/openwebrx-experimental.list
apt-get install -y wget gpg
wget -O - https://repo.openwebrx.de/debian/key.gpg.txt | gpg --dearmor -o /usr/share/keyrings/openwebrx.gpg
echo "deb [signed-by=/usr/share/keyrings/openwebrx.gpg] https://repo.openwebrx.de/debian/ bullseye main" > /etc/apt/sources.list.d/openwebrx-bullseye.list
apt-get update

apt-get install -y --no-install-recommends $BUILD_PACKAGES
cd

echo "+ Build MBELIB..."
git clone https://github.com/szechyjs/mbelib.git
cd mbelib
dpkg-buildpackage
cd ..
dpkg -i libmbe1_1.3.0_*.deb libmbe-dev_1.3.0_*.deb

echo "+ Build codecserver-softmbe..."
git clone https://github.com/knatterfunker/codecserver-softmbe.git
cd codecserver-softmbe
# ignore missing library linking error in dpkg-buildpackage command
sed -i 's/dh \$@/dh \$@ --dpkg-shlibdeps-params=--ignore-missing-info/' debian/rules
dpkg-buildpackage
cd ..

mkdir /deb
mv *.deb /deb/
cd /deb
apt download libcodecserver
ls -la /deb

dpkg -i /deb/libmbe1_1.3.0_*.deb


echo "+ Install codecserver-softmbe..."
dpkg -i /deb/libcodecserver_*.deb
dpkg -i /deb/codecserver-driver-softmbe_0.0.1_*.deb
rm -rf /deb

# add the softmbe library to the codecserver config
linklib=$(dpkg -L codecserver-driver-softmbe | grep libsoftmbe.so)
ln -s $linklib /usr/local/lib/codecserver/
mkdir -p /usr/local/etc/codecserver
#cat >> /etc/codecserver/codecserver.conf << _EOF_
cat >> /usr/local/etc/codecserver/codecserver.conf << _EOF_

# add softmbe
[device:softmbe]
driver=softmbe
_EOF_

#mkdir -p /etc/services.d/codecserver
#cat >> /etc/services.d/codecserver/run << _EOF_
##!/usr/bin/execlineb -P
#/usr/bin/codecserver
#_EOF_

sed -i 's/set -euo pipefail/set -euo pipefail\ncd \/opt\/openwebrx/' /opt/openwebrx/docker/scripts/run.sh
sed -i 's/set -euo pipefail/set -euo pipefail\ncd \/opt\/openwebrx/' /run.sh

apt-get -y purge --autoremove $BUILD_PACKAGES
apt-get clean
rm -rf /var/lib/apt/lists/*
