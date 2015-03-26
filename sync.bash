#!/bin/bash

# sync cfitsio upstream
rm -f cfitsio_latest.tar.gz
wget -c ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio_latest.tar.gz
tar xf cfitsio_latest.tar.gz

# sync m4 macros from autoconf archive
for macro in prog_flex prog_bison; do
    wget http://git.savannah.gnu.org/cgit/autoconf-archive.git/plain/m4/ax_${macro}.m4 \
	-O autotools/m4/ax_${macro}.m4 
done

# update version number and add a zero to fit upstream versioning
PV="$(awk -F , '/CFITSIO_MAJOR/{print $2}' cfitsio/configure.in | sed -e 's|)||')"
PV="${PV}.$(awk -F , '/CFITSIO_MINOR/{print $2}' cfitsio/configure.in | sed -e 's|)||')"
sed -i -e "/AC_INIT/s/[[:digit:]]\.[[:digit:]]\{3\}/${PV}/" autotools/configure.ac
