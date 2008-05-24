#
# "$Id: Makefile 7558 2008-05-12 23:46:44Z mike $"
#
#   Backend makefile for the Common UNIX Printing System (CUPS).
#
#   Copyright 2007-2008 by Apple Inc.
#   Copyright 1997-2007 by Easy Software Products, all rights reserved.
#
#   These coded instructions, statements, and computer programs are the
#   property of Apple Inc. and are protected by Federal copyright
#   law.  Distribution and use rights are outlined in the file "LICENSE.txt"
#   which should have been included with this file.  If this file is
#   file is missing or damaged, see the license at "http://www.cups.org/".
#
#   This file is subject to the Apple OS-Developed Software exception.
#

# include ../Makedefs

TARGETS	=	usb2
OBJS	=	usb.o ieee1284.o


#
# Make all targets...
#

all:	$(TARGETS)


#
# Make library targets...
#

libs:


#
# Clean all object files...
#

clean:
	$(RM) $(OBJS) $(TARGETS) $(LIBOBJS)


#
# Update dependencies (without system header dependencies...)
#

depend:
	makedepend -Y -I.. -fDependencies $(OBJS:.o=.c) >/dev/null 2>&1


#
# Install all targets...
#

install:	all install-data install-headers install-libs install-exec


#
# Install data files...
#

install-data:


#
# Install programs...
#

install-exec:
	$(INSTALL_DIR) -m 755 $(SERVERBIN)/backend
	for file in $(RBACKENDS); do \
		$(LIBTOOL) $(INSTALL_BIN) -m 700 $$file $(SERVERBIN)/backend; \
	done
	for file in $(UBACKENDS); do \
		$(INSTALL_BIN) $$file $(SERVERBIN)/backend; \
	done
	$(RM) $(SERVERBIN)/backend/http
	$(LN) ipp $(SERVERBIN)/backend/http
	if test "x$(SYMROOT)" != "x"; then \
		$(INSTALL_DIR) $(SYMROOT); \
		for file in $(TARGETS); do \
			cp $$file $(SYMROOT); \
		done \
	fi


#
# Install headers...
#

install-headers:


#
# Install libraries...
#

install-libs:


#
# Uninstall all targets...
#

uninstall:
	for file in $(RBACKENDS) $(UBACKENDS); do \
		$(RM) $(SERVERBIN)/backend/$$file; \
	done
	$(RM) $(SERVERBIN)/backend/http
	-$(RMDIR) $(SERVERBIN)/backend
	-$(RMDIR) $(SERVERBIN)

#
# usb2
#

usb2:	usb.o ieee1284.o runloop.o
	echo Linking $@...
	$(CC) $(LDFLAGS) -lcups -o usb $?
usb.o:	usb.c usb-darwin.c usb-unix.c


.SILENT:
.SUFFIXES:	.1 .1.gz .1m .1m.gz .5 .5.gz .7 .7.gz .8 .8.gz .a .c .cxx .h .man .o .32.o .64.o .gz

.c.o:
	echo Compiling $<...
	$(CC) $(ARCHFLAGS) $(OPTIM) $(ALL_CFLAGS) -I/usr/include/cups/ -I. -I./include/ -c $<

#
# Dependencies...
#

# include Dependencies


#
# End of "$Id: Makefile 7558 2008-05-12 23:46:44Z mike $".
#
