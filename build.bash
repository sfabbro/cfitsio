#!/bin/bash

# need to run sync.bash before?
[ $# -ge 1 ] &&  ./sync.bash $1

if [ -e cfitsio.tar.gz ]; then
    tar xf cfitsio.tar.gz
else
    echo "missing tar file, sync or provide a version"
    exit 1
fi

# copy and apply changes
cp -r addons/* cfitsio/

pushd cfitsio
for p in patches/*.patch; do
    echo ">> Applying $p"
    patch -p0 < ${p}
done

# remove upstream build system
rm -f configure configure.in Makefile.in

# make tar ball
autoreconf -vi && ./configure && make distcheck
popd
[ -e cfitsio/cfitsio-*.tar.gz ] && mv cfitsio/cfitsio-*.tar.gz .
