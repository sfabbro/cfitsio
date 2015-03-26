#
# SYNOPSIS
#
#   AX_ZLIB([ACTION-IF-FOUND[, ACTION-IF-NOT-FOUND]])
#
# DESCRIPTION
#
#   This macro looks for the zlib library (http://zlib.net/).
#   On success, it sets the ZLIB_LIBS and ZLIB_CFLAGS output variables to hold the
#   requisite library linkages and compiler directives. It first look for a pkg-config file
#   before trying to compile and link with zlib.
#
#   To link with ZLIB, you should link with:
#
#     $ZLIB_LIBS $LIBS
#
#   ACTION-IF-FOUND is a list of shell commands to run if the ZLIB
#   library is found, and ACTION-IF-NOT-FOUND is a list of commands to
#   run it if it is not found. If ACTION-IF-FOUND is not specified, the
#   default action will define the processor macro HAVE_ZLIB. 
#
# LICENSE
#
#   Copyright (c) 2012 Sebastien Fabbro <sfabbro@uvic.ca>
#
#   This program is free software: you can redistribute it and/or modify it
#   under the terms of the GNU General Public License as published by the
#   Free Software Foundation, either version 3 of the License, or (at your
#   option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
#   Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program. If not, see <http://www.gnu.org/licenses/>.
#
#   As a special exception, the respective Autoconf Macro's copyright owner
#   gives unlimited permission to copy, distribute and modify the configure
#   scripts that are the output of Autoconf when processing the Macro. You
#   need not follow the terms of the GNU General Public License when using
#   or distributing such scripts, even though portions of the text of the
#   Macro appear in them. The GNU General Public License (GPL) does govern
#   all other use of the material that constitutes the Autoconf Macro.
#
#   This special exception to the GPL applies to versions of the Autoconf
#   Macro released by the Autoconf Archive. When you make and distribute a
#   modified version of the Autoconf Macro, you may extend this special
#   exception to the GPL to apply to your modified version as well.


AC_DEFUN([AX_ZLIB],[

ax_zlib_ok=no

PKG_CHECK_MODULES(ZLIB, zlib, [ax_zlib_ok=yes], [ax_zlib_ok=no])

if test x"$ax_zlib_ok" = x"no"; then
   # if neither pkg-config file found, nor ZLIB_LIBS defined
   if test x$ZLIB_LIBS = x ; then
      ZLIB_LIBS="-lz"
      AC_ARG_WITH([zlib-libdir],
	 [  --with-zlib-libdir=DIR directory where the library was installed],
	 [ZLIB_LIBS="-L$withval $ZLIB_LIBS"], )
   fi
   ax_zlib_lib_ok=no
   LIBS_sav="$LIBS"
   LIBS="$LIBS $ZLIB_LIBS"
   AC_CHECK_LIB([z], [inflateEnd], [ax_zlib_lib_ok=yes], [AC_MSG_WARN([  *** zlib library not found])])

   # if neither pkg-config file found, nor ZLIB_CFLAGS defined
   if test x$ZLIB_CFLAGS = x ; then
      ZLIB_CFLAGS=""
      AC_ARG_WITH(zlib-includedir,
	 [  --with-zlib-includedir=DIR directory where the headers were installed],
	 [ZLIB_CFLAGS="-I$withval"], )
   fi
   ax_zlib_hdr_ok=no
   CPPFLAGS_sav="$CPPFLAGS"
   CPPFLAGS="$CPPFLAGS $ZLIB_CFLAGS"
   AC_CHECK_HEADER([zlib.h],
      [ax_zlib_hdr_ok=yes],
      [AC_MSG_WARN([  *** zlib headers not found.])])

   if test x$ax_zlib_lib_ok = xyes -a x$ax_zlib_hdr_ok = xyes; then
      ax_zlib_ok=yes
   fi
   AC_SUBST(ZLIB_CFLAGS)
   AC_SUBST(ZLIB_LIBS)
   LIBS="$LIBS_sav"
   CPPFLAGS="$CPPFLAGS_sav"
fi


# Finally, execute ACTION-IF-FOUND/ACTION-IF-NOT-FOUND:
if test x"$ax_zlib_ok" = x"yes"; then
        ifelse([$1],,AC_DEFINE(HAVE_ZLIB, [1], [Define if you have ZLIB library.]),[$1])
        :
else
        ax_zlib_ok=no
        $2
fi
])
