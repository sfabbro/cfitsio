#!/bin/sh

VERSION=${1:-3.260}

UT="cfitsio${VERSION/./}.tar.gz"
echo " >>> Fetching ${UT} ..."
wget -q -c "ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/${UT}"
[ ! -e "${UT}" ] && echo "   error fetching upstream ${UT}" && exit
tar xfz ${UT}

echo " >>> Fetching patches ..."
pushd cfitsio > /dev/null
for f in configure.ac Makefile.am ax_pthread.m4 ax_check_zlib.m4 cfitsio-autoheader.patch; do
    wget -q http://gitorious.org/poloka/cfitsio/blobs/raw/master/${f}
    [ ! -e  ${f} ] && echo "   error fetching patch $f" && exit
done
patch -sp0 < cfitsio-autoheader.patch
sed -i -e "s/@VERSION@/${version}/" configure.ac
echo " >>> Producing new tar ball ..."
rm -f Makefile.in configure.in
autoreconf -i &> /dev/null
./configure -q > /dev/null
make -s distcheck
P="cfitsio-${VERSION}"
[ ! -e "${P}.tar.gz" ] && echo "   error producing tar ball" && exit

mv ${P}.tar.gz ../
popd > /dev/null
rm -rf cfitsio/ ${UT}
echo " >>> ${P}.tar.gz is ready"
