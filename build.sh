#!/bin/sh

# need to run sync.sh before?
# ./sync.sh
tar xf cfitsio.tar.gz

# copy and apply changes
cp -r addons/* cfitsio/

pushd cfitsio
for p in patches/*.patch; do
    patch -p0 < ${p}
done

# remove upstream build system
rm -f configure configure.in Makefile.in

# make tar ball
autoreconf -vi && ./configure && make distcheck
popd
[ -e cfitsio/cfitsio-*.tar.gz ] && mv cfitsio/cfitsio-*.tar.gz .
