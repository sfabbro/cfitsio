#!/bin/bash

version="${1:-3.250}"
echo " >>> Repacking cfitsio version ${version}"
echo
wget ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio${version/./}.tar.gz
tar xf cfitsio${version/./}.tar.gz
pushd cfitsio > /dev/null
wget http://gitorious.org/poloka/cfitsio/blobs/raw/master/configure.ac
wget http://gitorious.org/poloka/cfitsio/blobs/raw/master/Makefile.am
wget "http://git.savannah.gnu.org/gitweb/?p=autoconf-archive.git;a=blob_plain;f=m4/ax_pthread.m4" -O ax_pthread.m4
sed -i -e "s/@VERSION@/${version}/" configure.ac
rm -f Makefile.in configure.in
autoreconf -fi 
popd > /dev/null
echo
echo " >>> Now run ./cfitsio/configure --help to see your compile options"
echo
