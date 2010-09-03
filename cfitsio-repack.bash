#!/bin/bash

do-make() {
    echo " >>> Running make $1 ..."
    make -j2 $1 &> $1.log
    if [ $? -ne 0 ]; then
	echo "error for target $1, see cfitsio-build/$1.log"
	exit
    fi
}


VERSION=${1:-3.250}
P="cfitsio-${VERSION}"
NP="cfitsio${VERSION/./}"

echo " >>> Fetching ${NP}..."
wget -q -c ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/${NP}.tar.gz
tar xfz ${NP}.tar.gz
echo " >>> Repacking cfitsio..."
pushd cfitsio > /dev/null
wget -q http://gitorious.org/poloka/cfitsio/blobs/raw/master/configure.ac
wget -q http://gitorious.org/poloka/cfitsio/blobs/raw/master/Makefile.am
wget -q "http://git.savannah.gnu.org/gitweb/?p=autoconf-archive.git;a=blob_plain;f=m4/ax_pthread.m4" -O ax_pthread.m4
sed -i -e "s/@VERSION@/${version}/" configure.ac
rm -f Makefile.in configure.in
autoreconf -fi &> /dev/null
./configure -q > /dev/null
make -s dist 
[[ ! -e ${P}.tar.gz ]] && echo " error producing tar ball" && exit
mv ${P}.tar.gz ../
popd > /dev/null
#rm -rf cfitsio/ ${NP}
rm -rf cfitsio/
echo " >>> ${P}.tar.gz is ready"
echo -n " >>> Now do you want to install it [y/n]? "
read answer
[[ ${answer} == n* ]] && exit
tar xfz ${P}.tar.gz
mkdir -p cfitsio-build
pushd cfitsio-build &> /dev/null
echo -n " >>> Installation prefix directory: "
read dir
echo " >>> Configuring cfitsio..."
../${P}/configure --prefix="${dir}" CFLAGS=-O2 FFLAGS=-O2 &> configure.log || \
    echo "error during configuration see cfitsio-build/configure.log"
[ $? -ne 0 ] && exit
do-make all
do-make check
do-make install
popd &> /dev/null
echo " >>> cfitsio library and execs are now installed"
rm -rf ${P} cfitsio-build
