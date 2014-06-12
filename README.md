CFITSIO
=======


This is a repackaging of the FITS I/O library cfitsio using modern
autotools and some other minor changes, mostly to satisfy Linux
distributions QA, but also usability and robustness.

The cfitsio tar balls can be fetched from this directory:

http://dev.gentoo.org/~bicatali/distfiles/

To see the full list of changes with respect to HEASARC CFITSIO
library, read the Changes.md file.

To build cfitsio, use the traditional commands:
```
  $ ./configure
  $ make
  $ make check [will test cfitsio]
  $ make install
```

To see the list of all options to build cfitsio, run configure
--help. We introduced the following new options for the user:

  --enable-threads  : build with multi-threading (replace --enable-reentrant)
  --disable-fortran : will not build the fortran wrappers
  --disable-static  : will not build the static library
  --disable-shared  : will not build the shared library
  --disable-tools   : will not build fpack, funpack, imcopy, fitscopy, listhead


If you are using this cfitsio directly from a clone of the git
repository on github, read INSTALL.md.
