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

 * --enable-threads  build with multi-threading (replace --enable-reentrant)
 * --disable-fortran will not build the fortran wrappers
 * --disable-static  will not build the static library
 * --disable-shared  will not build the shared library
 * --disable-tools   will not build fpack, funpack, imcopy, fitscopy, listhead

To see the full list of changes, read the Changes.rst file.
