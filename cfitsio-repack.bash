#!/bin/bash

version=${1:-3.250}
wget ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio${version/./}.tar.gz
tar xf cfitsio${version/./}.tar.gz
cd cfitsio
wget http://gitorious.org/poloka/cfitsio/blobs/raw/master/configure.ac
wget http://gitorious.org/poloka/cfitsio/blobs/raw/master/Makefile.a
wget http://gitorious.org/poloka/cfitsio/blobs/raw/master/ax_pthreads.m4
sed -i -e "s/@VERSION@/${version}/" configure.ac
autoreconf -fvi
