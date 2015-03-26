CFITSIO
=======

This is a repackaging of the FITS I/O library cfitsio using modern
autotools, and applying other minor changes.

It will produce cfitsio tar balls. Casual users will find those
re-packaged versions in:

http://dev.gentoo.org/~bicatali/distfiles/

To see the full list of changes with respect to HEASARC CFITSIO
library, read the CHANGES.md file.

To build cfitsio, use the traditional commands:
```
  $ ./configure
  $ make
  $ make check
  $ sudo make install
```

To see the list of all options to build cfitsio, run configure
--help. We introduced the following new options for the user:

  --enable-threads  : build with multi-threading
  --disable-fortran : will not build the fortran wrappers
  --disable-static  : will not build the static library
  --disable-shared  : will not build the shared library
  --disable-tools   : will not build fpack, funpack, imcopy, fitscopy, listhead
  --withtout-bzip2  : will not build cfitsio library with bzip2 loading capabilities


If you are interested in contributing to this re-packaging, see
https://github.com/sfabbro/cfitsio, instructions on BUILD.md.
