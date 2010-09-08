#!/bin/sh

VERSION=${1:-3.250}

UT="cfitsio${VERSION/./}.tar.gz"
echo -n " >>> Fetching ${UT} ... "
wget -q -c "ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/${UT}"
[ ! -e "${UT}" ] && echo "\n   error fetching upstream tar ball" && exit
tar xfz ${UT}
echo "OK"

echo -n " >>> Fetching patches ... "
pushd cfitsio > /dev/null
wget -q http://gitorious.org/poloka/cfitsio/blobs/raw/master/configure.ac
wget -q http://gitorious.org/poloka/cfitsio/blobs/raw/master/Makefile.am
wget -q http://gitorious.org/poloka/cfitsio/blobs/raw/master/ax_pthread.m4
[ ! -e configure.ac -o ! -e Makefile.am -o ! -e ax_pthread.m4 ] && echo "\n   error fetching patches" && exit
sed -i -e "s/@VERSION@/${version}/" configure.ac
echo "OK"

echo -n " >>> Producing new tar ball ... "
rm -f Makefile.in configure.in
autoreconf -i &> /dev/null
./configure -q > /dev/null
make -s distcheck
P="cfitsio-${VERSION}"
[ ! -e "${P}.tar.gz" ] && echo "\n   error producing tar ball" && exit
echo "OK"

mv ${P}.tar.gz ../
popd > /dev/null
rm -rf cfitsio/ ${UT}
echo " >>> ${P}.tar.gz is ready"
