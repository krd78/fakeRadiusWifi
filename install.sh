#!/bin/sh

FREERADIUS_LINK=\
ftp://ftp.freeradius.org/pub/radius/old/freeradius-server-2.1.12.tar.bz2
WPE_PATCH_LINK=\
https://raw.github.com/brad-anton/freeradius-wpe/master/freeradius-wpe.patch

wget $FREERADIUS_LINK
wget $WPE_PATCH_LINK
tar xvf freeradius-server-2.1.12.tar.bz2
cd freeradius-server-2.1.12

patch -p1 < ../freeradius-wpe.patch
./configure
make
sudo make install
sudo ldconfig
