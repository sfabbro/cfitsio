#!/bin/bash

# sync cfitsio upstream
rm -f cfitsio_latest.tar.gz
wget -c ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio_latest.tar.gz

# sync m4 macro
wget http://git.savannah.gnu.org/cgit/autoconf-archive.git/plain/m4/ax_pthread.m4 \
    -O autotools/m4/ax_pthread.m4 

tar xf cfitsio_latest.tar.gz

PV="$(awk -F , '/CFITSIO_MAJOR/{print $2}' cfitsio/configure.in | sed -e 's|)||')"
PV="${PV}.$(awk -F , '/CFITSIO_MINOR/{print $2}' cfitsio/configure.in | sed -e 's|)||')"
# update version number
sed -i -e "/AC_INIT/s/[[:digit:]]\.[[:digit:]]\{3\}/${PV}/" autotools/configure.ac
