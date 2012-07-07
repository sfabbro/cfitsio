#!/bin/sh

# copy and apply changes
cp -r addons/* cfitsio/

pushd cfitsio
for p in patches/*.patch; do
    patch -p0 < ${p}
done

# remove upstream build system
rm -f configure Makefile.in

# make tar ball
autoreconf -vi
./configure
make distcheck
popd
mv cfitsio/cfitsio-*.tar.gz .
