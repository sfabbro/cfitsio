AC_PREREQ(2.59)
AC_INIT([cfitsio], [@VERSION@], [pence@tetra.gsfc.nasa.gov])
AC_CONFIG_SRCDIR([fitscore.c])
AM_INIT_AUTOMAKE([foreign])
AC_CANONICAL_HOST

AC_MSG_CHECKING([whether to enable POSIX threads])
AC_ARG_ENABLE([threads],
   [AS_HELP_STRING([--enable-threads], [Enable POSIX threads [default=yes]])],
   [enable_threads=$enableval],
   [enable_threads=no])

sinclude(ax_pthread.m4)
AX_PTHREAD(,[enable_threads=no])
if test x"$enable_threads" != xno; then
    LIBS="$PTHREAD_LIBS $LIBS"
    CFLAGS="$PTHREAD_CFLAGS $CFLAGS"
    CC="$PTHREAD_CC"
    AC_DEFINE(_REENTRANT)
fi

AC_PROG_YACC
AC_PROG_LEX

AC_MSG_CHECKING([whether to enable fortran interface])
AC_ARG_ENABLE(fortran,
    AC_HELP_STRING([--enable-fortran],
                   [Compile the fortran interface (default=yes)]), 
		   [ENABLE_FORTRAN=$enableval],
                   [ENABLE_FORTRAN=yes])

case x"$ENABLE_FORTRAN" in
 xno)
    ENABLE_FORTRAN=no
    # disable fortran libtool checks
    define([AC_LIBTOOL_LANG_F77_CONFIG], [:])
    AC_MSG_RESULT([no])
    ;;
 *)
    ENABLE_FORTRAN=yes
    AC_MSG_RESULT([yes])
    AC_PROG_F77
    if test x$F77 = xg77; then
      cfortran_def=g77Fortran
    elif test x$F77 = xifort ; then
      cfortran_def=INTEL_COMPILER
    elif test x$F77 = xgfortran ; then
      cfortran_def=gFortran
    elif test x$F77 = xpgf77 ; then
      cfortran_def=pgiFortran
    else
      cfortran_def=f2cFortran
    fi
    CPPFLAGS_FORTRAN="-D$cfortran_def"
    AC_SUBST(CPPFLAGS_FORTRAN)
    ;;
esac

AC_SUBST([ENABLE_FORTRAN])
AM_CONDITIONAL([ENABLE_FORTRAN], test "x$ENABLE_FORTRAN" = "xyes")

# disable cxx libtool check
define([AC_LIBTOOL_LANG_CXX_CONFIG], [:])
AC_PROG_LIBTOOL
dnl no api version info, so simply copy package version
SHARED_VERSION_INFO="3:0:0"
AC_SUBST(SHARED_VERSION_INFO)



case $host in
    *apple*darwin*)
	dnl may break Absoft compilers
	AC_DEFINE(_LARGEFILE_SOURCE, [1], 
		  [Define to 1 if you have large file support])
	AC_DEFINE(_FILE_OFFSET_BITS, [64],
 		  [Offsets bits in files])
	;;
    *hppa*)
	CPPFLAGS_EXTRA="-DPG_PPU"
	;;
    *sunos5*)
	AC_DEFINE(_LARGEFILE_SOURCE, [1], 
		  [Define to 1 if you have large file support])
	AC_DEFINE(_FILE_OFFSET_BITS, [64],
 		  [Offsets bits in files])
	CPPFLAGS_EXTRA="-DHAVE_ALLOCA_H -DHAVE_POSIX_SIGNALS"
	;;
    *irix*)
	CPPFLAGS_EXTRA="-DHAVE_POSIX_SIGNALS"
	;;
    *linux*)
	AC_DEFINE(_LARGEFILE_SOURCE, [1], 
		  [Define to 1 if you have large file support])
	AC_DEFINE(_FILE_OFFSET_BITS, [64],
 		  [Offsets bits in files])
	;;
    *cygwin*)
	CPPFLAGS_EXTRA="-DHAVE_POSIX_SIGNALS"
	;;
    *)
	;;
esac
AC_SUBST(CPPFLAGS_EXTRA)

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

# check for union semun type
AC_CHECK_TYPE(union semun,
   AC_DEFINE(HAVE_UNION_SEMUN, [1],
	[Define to 1 if you have semun in sys/sem.h]),,[
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
		]
)

dnl this quick check will add -lm to LIBS
AC_CHECK_LIB(m, cos)

AC_ARG_WITH([gsiftp-flavour],
  [AC_HELP_STRING([--with-gsiftp-flavour[=PATH]], [Compile with a given Globus Toolkit gsiftp protocol flavour])],
  ,
  [withval=no])

case x$withval in
  xno)
      AC_MSG_CHECKING([for Globus flavor])
      AC_MSG_RESULT([none])
      ;;
  xyes)
      AC_MSG_RESULT([yes])
      ;;
  *)
   AC_MSG_RESULT([$withval])
   GSIFTP_FLAVOUR=$withval
   AC_DEFINE(GSIFTP_FLAVOUR, [1], 
	    [Define to 1 if you want Globus Toolkit architecture])
   ;;
esac

AC_ARG_WITH(gsiftp,
    [AC_HELP_STRING([--with-gsiftp[=PATH]], [Compile with Globus Toolkit gsiftp protocol support [default=no]])],
    ,
    [withval=no])
case "x$withval" in
  xno)
      AC_MSG_CHECKING([for Globus Toolkit])
      AC_MSG_RESULT([no])
      ;;
  xyes)
      AC_MSG_RESULT([yes])
      ;;
  *)
      AC_MSG_RESULT([yes])
      CPPFLAGS_GLOBUS="-I${withval}/include/${GSIFTP_FLAVOUR}"
      LIBS_GLOBUS="-L${withval}/lib -lglobus_ftp_client_${GSIFTP_FLAVOUR}"
      HAVE_GSIFTP=yes
      AC_DEFINE(HAVE_GSIFTP, [1],
	    [Define if you want Globus Toolkit gsiftp protocol support])
	    ;;
esac

AC_SUBST(CPPFLAGS_GLOBUS)
AC_SUBST(LIBS_GLOBUS)
AC_CONFIG_FILES([Makefile cfitsio.pc])
AC_OUTPUT
