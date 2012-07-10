#!/bin/sh

[ $# -lt 1 ] && echo "$0 <cfitsio version>" && exit

PV=${1}

# sync cfitsio upstream
wget -nc -c ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio${PV/./}.tar.gz
ln -sfn cfitsio${PV/./}.tar.gz cfitsio.tar.gz 

# sync m4 macro
wget http://git.savannah.gnu.org/cgit/autoconf-archive.git/plain/m4/ax_pthread.m4 \
    -O addons/m4/ax_pthread.m4 

# update version number
sed -i -e "/AC_INIT/s/[[:digit:]].[[:digit:]]{3}/${PV}/" addons/configure.ac
