#!/bin/bash

tar xf cfitsio_latest.tar.gz

# copy our documentation build system
cp -r README.md CHANGES.md autotools/* cfitsio/

pushd cfitsio
version=$(awk '/CFITSIO_VERSION/ {print $3}' fitsio.h)
soname=$(sed -n -e '/AC_SUBST(CFITSIO_SONAME/s/.*,\(.*\))/\1/p' configure.in)

sed -e "s/@VERSION@/${version}/" \
    -e "s/@SONAME@/${soname}/" \
    -i configure.ac

# remove upstream build system to avoid automake ambiguity
rm -f configure configure.in Makefile.in

# apply patches if any
for p in ../patches/*.patch; do
    echo ">> Applying $p"
    patch -p1 < ${p}
done
# produce make files, compile, run unit tests, make tar ball
autoreconf -vi && ./configure && make distcheck
popd

[ -e cfitsio/cfitsio-*.tar.gz ] && mv cfitsio/cfitsio-*.tar.gz .
