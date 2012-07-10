Changes from upstream cfitsio
=============================

Here is the list of differences with the HEASARC, NASA/GSFC cfitsio
upstream [1]:

* zlib is unbundled and cfitsio is linked to zlib system libraries 

* the listhead exec has been re-introduced (it was removed from upstream
  3.270 and above)

* a fitsio_config.h is included to some source and header files to allow
  definition of preprocessing macros used at build time. It gives
  users the ability to compile their programs against cfitsio without
  extra flags (such as -DREENTRANT, etc...)

* the ax_cfitsio.m4 file which can be used in packages with autoconf
  depending on cfitsio

Other internal fixes are listed below.

Build system
------------

* Use of libtool, which comes with all the libtool goodness for
  compiler and linker platform wrapping and shared/static easiness of
  building.

* A new ax_zlib.m4 macro is used to check the stock zlib compatibility,
  by first checking a pkg-config file.

* The executable tools fpack, funpack, imcopy, fitscopy, and listhead are
  built by default. Disable with --without-tools.

* An option to build cfitsio without fortran (--disable-fortran) has
  been introduced

* The Globus ftp detection (--with-gsiftp option) has been rewritten

* Threading uses a more standard autoconf macro ax_pthread.m4 from the
  autoconf archive [2], resulting in the more intuitive option
  --enable-threads instead of --enable-reentrant

* simple unit testing now can be compiled and executed with "make check"

* Modern and portable autoconf macros are used to check existing
  functions and libraries

* Use of autoheader to generate fitsio_config.h at configure
  time that will be installed. Packages dependent on cfitsio can
  therefore check whether cfitsio was compiled with a specific
  feature

* The generated parsing files (eval_*) are now built using the BUILT_SOURCES
  feature of automake.

* pkg-config file uses all libraries and is versioned at configure time


Code fixes
----------

We try to keep synchronized with upstream as much as possible.
Some patches are applied to the code itself if we think they are
necessary. If we apply patches, they will be located in the addons/patches
directory. Some are from Gentoo, other are inspired from users or
other distributions ([3],[4]).

Note
----

We have tried twice to give upstream some hints that some of this work
could be applied, but have never got any answer. Feel free to lobby.


References
----------
[1] http://heasarc.gsfc.nasa.gov/fitsio/fitsio.html

[2] http://git.savannah.gnu.org/cgit/autoconf-archive.git

[3] http://pkgs.fedoraproject.org/gitweb/?p=cfitsio.git

[4] http://packages.qa.debian.org/c/cfitsio3.html
