#!/bin/bash

version="${1:-3.250}"
echo " >>> Repacking cfitsio version ${version}"
echo
wget ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio${version/./}.tar.gz
tar xf cfitsio${version/./}.tar.gz
cd cfitsio
wget http://gitorious.org/poloka/cfitsio/blobs/raw/master/configure.ac
wget http://gitorious.org/poloka/cfitsio/blobs/raw/master/Makefile.am
wget "http://git.savannah.gnu.org/gitweb/?p=autoconf-archive.git;a=blob_plain;f=m4/ax_pthread.m4" -O ax_pthread.m4
sed -i -e "s/@VERSION@/${version}/" configure.ac
rm -f Makefile.in cfitsio.in
autoreconf -fi 
echo
echo " >>> Now run ./configure with your options (--help is your friend)"

