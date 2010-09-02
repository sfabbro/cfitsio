#!/bin/bash

VERSION=${1:-3.250}
P="cfitsio-${VERSION}"
NP="cfitsio${VERSION/./}"

echo " >>> Fetching ${NP}..."
wget -q ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/${NP}.tar.gz
tar xf ${NP}.tar.gz
echo " >>> Repacking cfitsio..."
pushd cfitsio > /dev/null
wget -q http://gitorious.org/poloka/cfitsio/blobs/raw/master/configure.ac
wget -q http://gitorious.org/poloka/cfitsio/blobs/raw/master/Makefile.am
wget -q "http://git.savannah.gnu.org/gitweb/?p=autoconf-archive.git;a=blob_plain;f=m4/ax_pthread.m4" -O ax_pthread.m4
sed -i -e "s/@VERSION@/${version}/" configure.ac
rm -f Makefile.in configure.in
autoreconf -fi &> /dev/null
./configure > /dev/null
make -s dist 
cp ${P}.tar.gz ../
popd > /dev/null
rm -rf cfitsio/ ${NP}.tar.gz
echo " >>> cfitsio-${version}.tar.gz is ready"
