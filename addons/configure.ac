AC_INIT([cfitsio],[3.350],[William.D.Pence@nasa.gov])

AC_CONFIG_SRCDIR([fitscore.c])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR(autoconf)
AM_INIT_AUTOMAKE([foreign])
AC_CONFIG_MACRO_DIR([m4])
AC_CANONICAL_HOST

AC_PROG_YACC
AC_PROG_LEX
dnl AC_PROG_SED
dnl AC_PROG_SED is available only in autoconf 2.60 and later.
dnl With older autoconf, assume that 'sed' is ok.
ifdef([AC_PROG_SED], [AC_PROG_SED], [SED=sed AC_SUBST(SED)])

AC_MSG_CHECKING([whether to enable fortran interface])
AC_ARG_ENABLE([fortran],
    AS_HELP_STRING([--disable-fortran],[Disable compilation of the fortran interface]), 
		   [enable_fortran=$enableval],
                   [enable_fortran=yes])

if test x"$enable_fortran" != xno; then
    AC_MSG_RESULT([yes])    
    AC_PROG_F77
    AC_F77_LIBRARY_LDFLAGS
    case x$F77 in
      x*g77) 
      	AC_DEFINE(g77Fortran, [1], [Define to 1 if you have g77 style fortran])
	;;
      x*ifort)
        AC_DEFINE(INTEL_COMPILER, [1], [Define to 1 if you have Intel style fortran])
	;;
      x*gfortran)
        AC_DEFINE(gFortran, [1], [Define to 1 if you have gfortran style fortran])
	;;
      x*pgf77)
        AC_DEFINE(pgiFortran, [1], [Define to 1 if you have Portland style fortran])
	;;
    	x*)
        AC_DEFINE(f2cFortran, [1], [Define to 1 if you have f2c style fortran])
	;;
    esac
else
    AC_MSG_RESULT([no])
fi
AM_CONDITIONAL([ENABLE_FORTRAN], [test x$enable_fortran = xyes])

AC_MSG_CHECKING([whether to build and install executable tools])
AC_ARG_ENABLE([tools],
    AS_HELP_STRING([--disable-tools],[Do not build the extra execs such funpack or imcopy]),
		   [enable_tools=$enableval],
                   [enable_tools=yes])

if test x"$enable_tools" != xno; then
    AC_MSG_RESULT([yes])    
else
    AC_MSG_RESULT([no])
fi
AM_CONDITIONAL([ENABLE_TOOLS], [test x$enable_tools = xyes])

ifdef([LT_INIT], 
      [LT_INIT LT_LANG([C])],
      [define([AC_LIBTOOL_LANG_CXX_CONFIG], [:]) AC_PROG_LIBTOOL])

dnl no api version info, so simply copy package version
SHARED_VERSION_INFO="1:0:0"
AC_SUBST(SHARED_VERSION_INFO)

AC_MSG_CHECKING([whether to enable POSIX threads])
AC_ARG_ENABLE([threads],
   [AS_HELP_STRING([--disable-threads], [Disable POSIX threads])],
   [enable_threads=$enableval],
   [enable_threads=yes])

if test x"$enable_threads" != xno; then
   AC_MSG_RESULT([yes])
   AX_PTHREAD(, [AC_MSG_ERROR([ *** POSIX Threads library not found.])])
   LIBS="$PTHREAD_LIBS $LIBS"
   CFLAGS="$CFLAGS $PTHREAD_CFLAGS"
   CC="$PTHREAD_CC"
   AC_DEFINE(_REENTRANT, [1], [Define to 1 if you have POSIX threads])
else
   AC_MSG_RESULT([no])
fi

# Define BUILD_HERA when building for HERA project to activate code in
# drvrfile.c (by way of fitsio2.h):
AC_MSG_CHECKING([whether we are building for HERA])
AC_ARG_ENABLE([hera],
    AS_HELP_STRING([--enable-hera],[Build for HERA (ASD use only)]), 
		   [enable_hera=$enableval],
                   [enable_hera=no])

# not much, hera has to define what to do with it
if test x"$enable_hera" != xno; then
   AC_MSG_RESULT([yes])
else
   AC_MSG_RESULT([no])
fi

PKG_CHECK_MODULES(ZLIB, zlib, [ax_zlib_ok=yes], [ax_zlib_ok=no])
if test x"$ax_zlib_ok" = x"no"; then
   AX_ZLIB(,[AC_MSG_ERROR([ *** zlib headers and/or library not found])])
   PC_SHARED_LIBS=$ZLIB_LIBS
   REQUIRES=
else
   PC_SHARED_LIBS=
   REQUIRES="Requires: zlib"
fi
AC_SUBST(REQUIRES)
AC_SUBST(PC_SHARED_LIBS)

AC_SYS_LARGEFILE

case $host in
    *hppa*)
	AC_DEFINE(PG_PPU, [1], [Define to 1 if you have PG PPU])
	;;
    *sunos5*)
	AC_DEFINE(POSIX_SIGNALS, [1],[Define to 1 if you have POSIX signals])
	AC_DEFINE(HAVE_ALLOCA_H, [1],[Define to 1 if you have alloca.h])
	;;
    *irix*)
	AC_DEFINE(POSIX_SIGNALS, [1],[Define to 1 if you have POSIX signals])
	;;
    *cygwin*)
	AC_DEFINE(POSIX_SIGNALS, [1],[Define to 1 if you have POSIX signals])
	;;
    *)
	;;
esac

AC_CHECK_FUNCS([ftruncate])
AC_CHECK_FUNCS([shmat shmdt shmget], 
    AC_DEFINE(HAVE_SHMEM_SERVICES, [1],
	[Define to yes if you have shared memory functions])
)
AC_CHECK_FUNCS([gethostbyname connect],
   [AC_DEFINE(HAVE_NET_SERVICES, [1], 
       [Define to 1 if you have network functions])]
)
AC_CHECK_TYPE(long long,
   [AC_DEFINE(HAVE_LONGLONG, [1], 
   	[Define to 1 if your compiler supports long long])]
)
dnl check for flock_t
AC_MSG_CHECKING([for flock_t in sys/fcntl.h])
AC_COMPILE_IFELSE(
	[AC_LANG_PROGRAM([[
#include <sys/fcntl.h>
			]], [[
flock_t filler;
			]])],
	[AC_DEFINE(HAVE_FLOCK_T, 1, [if you have flock_t])
	 AC_MSG_RESULT([yes])],
	[AC_MSG_RESULT([no]) ])

if test "$HAVE_FLOCK_T" != 1; then
   AC_MSG_CHECKING([for flock_t in sys/flock.h])
   AC_COMPILE_IFELSE([
	AC_LANG_PROGRAM([[
#include <sys/flock.h>
			]], [[
flock_t filler;
			]])],
	[AC_DEFINE(HAVE_FLOCK_T, 1, [if you have flock_t])
	 AC_MSG_RESULT([yes])],
	[AC_MSG_RESULT([no]) ])
fi

dnl check for union semun type
AC_CHECK_TYPE([union semun],
   AC_DEFINE(HAVE_UNION_SEMUN, [1],
	[Define to 1 if you have semun in sys/sem.h]),,[
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
		])

dnl this quick check will add -lm to LIBS
AC_CHECK_LIB([m], [cos])

dnl Globus stuff
AC_MSG_CHECKING([whether to build Globus ftp interface])
AC_ARG_WITH([gsiftp],
   [AS_HELP_STRING([--with-gsiftp@<:@=DIR@:>@],[Compile with Globus Toolkit gsiftp protocol support (default=no)])],
   [case $withval in
	yes | "" ) 
	    ;;
	*/*) 
	   gsiftp_dir="$withval"
	   ;;
	*) 
	   gsiftp_dir=none
	   ;;
    esac],
   [gsiftp_dir=none])

if test x"$gsiftp_dir" != xnone; then
   AC_MSG_RESULT([yes])
   AC_MSG_CHECKING([for Globus ftp flavour])
   AC_ARG_WITH([gsiftp-flavour],
     [AS_HELP_STRING([--with-gsiftp-flavour[=PATH]],[Compile with a given Globus Toolkit gsiftp protocol flavour (default: none)])],
     [gsiftp_flavour=$withval],
     [gsiftp_flavour=none])
   if test x$gsiftp_flavour = xnone; then
      AC_MSG_RESULT([none])
      gsiftp_libname="globus_ftp_client"
   else
      AC_MSG_RESULT([$gsiftp_flavour])
      gsiftp_libname="globus_ftp_client_$gsiftp_flavour"
  fi
  CPPFLAGS_sav="$CPPFLAGS"
  CPPFLAGS="$CPPFLAGS -I$gsiftp_dir/include/$gsiftp_flavour"
  AC_CHECK_HEADER([globus_ftp_client.h], ,[AC_MSG_ERROR([  *** Header file globus_ftp_client.h not found.])])
  CPPFLAGS="$CPPFLAGS_sav"
  LIBS_sav="$LIBS"
  LIBS="$LIBS -L$gsiftp_dir/lib"
  AC_CHECK_LIB([$gsiftp_libname], [gsiftp_get], , [AC_MSG_ERROR([ *** Library $gsiftp_libname not linked properly])])
  LIBS="$LIBS_sav"
  HAVE_GSIFTP=yes
  GSIFTP_CFLAGS="-I$gsiftp_dir/include/$gsiftp_flavour"
  GSIFTP_LIBS="-L$gsiftp_dir/lib -l$gsiftp_libname"
  AC_DEFINE(HAVE_GSIFTP, [1], [Define if you want Globus Toolkit gsiftp protocol support])
  AC_SUBST(GSIFTP_CFLAGS)
  AC_SUBST(GSIFTP_LIBS)
else
  AC_MSG_RESULT([no])
fi
AM_CONDITIONAL([WITH_GSIFTP], [test x$gsiftp_dir != xnone])

AC_CONFIG_FILES([Makefile cfitsio.pc])
AC_OUTPUT
