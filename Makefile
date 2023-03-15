# Makefile for Dinit.

PREFIX ?=	/usr/local

all: mconfig
	$(MAKE) -C build all
	$(MAKE) -C src all
	$(MAKE) -C doc/manpages all
	$(CC) $(CFLAGS) seedrng.c -o seedrng $(LDFLAGS)
	@echo "***"
	@echo "*** Build complete; use \"make check\" to run unit tests, \"make check-igr\" for"
	@echo "*** integration tests, or \"make install\" to install."
	@echo "***"

check: mconfig
	$(MAKE) -C src check

check-igr: mconfig
	$(MAKE) -C src check-igr

run-cppcheck:
	$(MAKE) -C src run-cppcheck

install: mconfig
	$(MAKE) -C src install
	$(MAKE) -C doc/manpages install
	install -d ${DESTDIR}/${PREFIX}/bin
	install -m755 seedrng ${DESTDIR}/${PREFIX}/bin/seedrng

clean:
	$(MAKE) -C src clean
	$(MAKE) -C build clean
	$(MAKE) -C doc/manpages clean

mconfig:
	@UNAME=`uname`;\
	if [ -f "./configs/mconfig.$$UNAME.sh" ]; then \
	    echo "*** Found auto-configuration script for OS: $$UNAME"; \
	    ( cd ./configs; sh "mconfig.$$UNAME.sh" ) \
	elif [ -f "./configs/mconfig.$$UNAME" ]; then \
	    echo "*** Found configuration for OS: $$UNAME"; \
	    ln -sf "configs/mconfig.$$UNAME" mconfig; \
	else \
	    ./configure; \
	fi
