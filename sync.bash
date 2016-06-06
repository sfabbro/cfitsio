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
