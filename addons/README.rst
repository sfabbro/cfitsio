=======
CFITSIO
=======


This is a repackaging of the FITS I/O library cfitsio using modern
autotools and some other minor changes, mostly to satisfy Linux
distributions QA, but also usability and robustness.

To build cfitsio, use the traditional commands:

 >  ./configure
 >  make
 >  make check [will test cfitsio]
 >  make install

To see options to build cfitsio, run configure --help. There are the
following extra options for the user:

 * --enable-threads  : allow multi-threading (replace --enable-reentrant)
 * --disable-fortran : don't building the fortran wrappers
 * --disable-static  : don't build the static library
 * --disable-shared  : don't build the shared library
 * --disable-tools   : don't build fpack, funpack, imcopy, fitscopy, listhead

To see the full list of changes, read the Changes.rst file.
