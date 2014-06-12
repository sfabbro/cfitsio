#!/bin/bash

# copy and apply changes
cp -r autotools/* cfitsio/
cp README.md Changes.md cfitsio/

pushd cfitsio
for p in ../patches/*.patch; do
    echo ">> Applying $p"
    patch -p0 < ${p}
done

# remove upstream build system
rm -f configure configure.in Makefile.in

# make tar ball
autoreconf -vi && ./configure && make distcheck
popd
[ -e cfitsio/cfitsio-*.tar.gz ] && mv cfitsio/cfitsio-*.tar.gz .
