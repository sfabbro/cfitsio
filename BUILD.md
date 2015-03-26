Building a cfitsio tar ball
===========================

To build this packaging of cfitsio from the git directory:

1. Sync with all the upstream sources:

 $ ./sync.bash

2. Build the new tar ball:

 $ ./build.bash

It should work. If not: file a pull request or an issue.

Requirements:

  * A C compiler
  * flex, bison, libtool, pkgconfig, automake, autoconf
  * zlib (zlib-dev on some distros)
  * Optional: bzip2 library (libbz2-dev on some distros)
  * Optional: a fortran compiler
