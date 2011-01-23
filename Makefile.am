BUILT_SOURCES = eval_y.c eval_l.c eval_tab.h
CLEANFILES = *~
MAINTAINERCLEANFILES = \
        aclocal.m4 \
        configure \
        Makefile.in \
        config.h \
        config.h.in \
        autoconf/* \
        stamp-* \
        cfitsio.pc \
	fitsio_config.h.in

DISTCLEANFILES = \
	$(BUILT_SOURCES) \
	testf77.fit \
	testprog.fit \
	y.output \
	my_*.out \
	btestfil.fit \
	speedcc.fit \
	atestfil.fit \
	ATESTFILEZ.FITS \
	BTESTFILEZ.FITS



lib_LTLIBRARIES = libcfitsio.la

C_SOURCES = \
	buffers.c cfileio.c checksum.c drvrfile.c drvrmem.c \
	drvrnet.c drvrsmem.c editcol.c edithdu.c eval_l.c \
	eval_y.c eval_f.c fitscore.c getcol.c getcolb.c getcold.c getcole.c \
	getcoli.c getcolj.c getcolk.c getcoll.c getcols.c getcolsb.c \
	getcoluk.c getcolui.c getcoluj.c getkey.c group.c grparser.c \
	histo.c iraffits.c \
	modkey.c putcol.c putcolb.c putcold.c putcole.c putcoli.c \
	putcolj.c putcolk.c putcoluk.c putcoll.c putcols.c putcolsb.c \
	putcolu.c putcolui.c putcoluj.c putkey.c region.c scalnull.c \
	swapproc.c wcssub.c wcsutil.c imcompress.c quantize.c ricecomp.c \
	pliocomp.c fits_hcompress.c fits_hdecompress.c zuncompress.c zcompress.c

if WITH_GSIFTP
C_SOURCES += drvrgsiftp.c drvrgsiftp.h
endif

F77_SOURCES=
if ENABLE_FORTRAN
F77_SOURCES += f77_wrap1.c f77_wrap2.c f77_wrap3.c f77_wrap4.c f77_wrap.h
endif

AM_YFLAGS = -d -v

include_HEADERS = fitsio_config.h fitsio.h fitsio2.h longnam.h drvrsmem.h
noinst_HEADERS = cfortran.h eval_defs.h f77_wrap.h  group.h \
	eval_tab.h fpack.h grparser.h region.h

libcfitsio_la_SOURCES = $(C_SOURCES) $(F77_SOURCES) $(include_HEADERS) $(noinst_HEADERS)
libcfitsio_la_CPPFLAGS = @GSIFTP_CFLAGS@ 
libcfitsio_la_LDFLAGS = -no-undefined -version-info @SHARED_VERSION_INFO@
libcfitsio_la_LIBADD = @GSIFTP_LIBS@

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = cfitsio.pc

LDADD = libcfitsio.la

bin_PROGRAMS = fitscopy imcopy fpack funpack
fitscopy_SOURCES = fitscopy.c
imcopy_SOURCES = imcopy.c
fpack_SOURCES = fpack.c fpackutil.c
funpack_SOURCES = funpack.c fpackutil.c

check_PROGRAMS = testprog speed cookbook smem
testprog_SOURCES = testprog.c
speed_SOURCES = speed.c
cookbook_SOURCES = cookbook.c
smem_SOURCES = smem.c
testprogs = testprog

if ENABLE_FORTRAN
check_PROGRAMS += testf77 cookbookf77
testf77_SOURCES = testf77.f
cookbookf77_SOURCES = cookbook.f
cookbookf77_FFLAGS = -W
testprogs += testf77
endif

EXTRA_DIST = README README.MacOS README.win32 \
	License.txt changes.txt \
	cfitsio.doc fitsio.doc cfitsio.tex fitsio.tex quick.tex \
	cfitsio.ps  fitsio.ps  quick.ps fpackguide.pdf \
	eval.l eval.y cookbook.f \
	testf77.std testprog.tpt testprog.std testf77.out testprog.out \
	iter_a.c iter_b.c iter_c.c iter_image.c iter_var.c \
	iter_a.f iter_b.f iter_c.f f77.inc \
	iter_a.fit iter_b.fit iter_c.fit

# hack to avoid dist target to rebuild testprog
%.out: ;

TESTS = $(check_PROGRAMS)

check-local: $(testprogs)
	@total=0; failed=0; \
	for i in $(testprogs); do \
		echo "--- Testing $$i ---"; \
		[ -e "$(top_builddir)"/testprog.tpt ] || \
		cp -f "$(top_srcdir)"/testprog.tpt "$(top_builddir)"/ ; \
		./$$i${EXEEXT} > my_$$i.out; \
		diff "$(top_srcdir)"/$$i.out my_$$i.out; \
		cmp $$i.fit "$(top_srcdir)"/$$i.std; \
		if [ "x$$?" = "x0" ]; then \
			echo "Test \`$$i' PASSED."; \
		else \
			echo "Test \`$$i' FAILED!!!"; \
			failed=$$(($$failed + 1)); \
		fi; \
		total=$$(($$total + 1)); \
	done; \
	if [ $$failed -gt 0 ]; then \
		echo "*** ERROR: $$failed/$$total tests failed!!!"; \
		echo ""; \
		exit 1; \
	fi
	if [ "$(top_builddir)" != "$(top_srcdir)" ]; then \
		rm -f $(top_builddir)/testprog.tpt; \
	fi

eval_l.c: Makefile
	@$(LEX) -t $(top_srcdir)/eval.l > eval_l.c1
	@$(SED) -e 's/yy/ff/g' -e 's/YY/FF/g' eval_l.c1 > eval_l.c
	@rm -f eval_l.c1

eval_y.c: eval_l.c
	@$(YACC) -d -v -y $(top_srcdir)/eval.y
	@$(SED) -e 's/yy/ff/g' -e 's/YY/FF/g' y.tab.c > eval_y.c
	@rm -f y.tab.c

eval_tab.h: eval_y.c
	@$(SED) -e 's/yy/ff/g' -e 's/YY/FF/g' y.tab.h > eval_tab.h
	@rm -f y.tab.h
