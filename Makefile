# Makefile for dungeon (Zork)
# Supports Unix, UNIVAC mainframe, and other platforms

# Platform selection
# To build for UNIVAC, use: make PLATFORM=UNIVAC
# To build for Unix (default), use: make
PLATFORM ?= UNIX

# Where to install the program
BINDIR = /usr/games

# Where to install the data file
DATADIR = /usr/games/lib

# Where to install the man page
MANDIR = /usr/share/man

# Platform-specific settings
ifeq ($(PLATFORM),UNIVAC)
  # UNIVAC mainframe settings
  CC = cc
  CFLAGS = -DUNIVAC -O
  LIBS =
  TERMFLAG = -DMORE_NONE
  TARGET = zork_univac
  GDTFLAG = -DALLOW_GDT
else
  # Unix/default settings
  CC = cc
  TARGET = zork
  GDTFLAG = -DALLOW_GDT

  # The dungeon program provides a ``more'' facility which tries to
  # figure out how many rows the terminal has.  Several mechanisms are
  # supported for determining this; the most common one has been left
  # uncommented.  If you have trouble, especially when linking, you may
  # have to select a different option.

  # more option 1: use the termcap routines.  On some systems the LIBS
  # variable may need to be set to -lcurses.  On some it may need to
  # be /usr/lib/termcap.o.  These options are commented out below.
  LIBS = -ltermcap
  TERMFLAG =
  # LIBS = -lcurses
  # LIBS = /usr/lib/termcap.o

  # more option 2: use the terminfo routines.  On some systems the LIBS
  # variable needs to be -lcursesX, but probably all such systems support
  # the termcap routines (option 1) anyhow.
  # LIBS = -lcurses
  # TERMFLAG = -DMORE_TERMINFO

  # more option 3: assume all terminals have 24 rows
  # LIBS =
  # TERMFLAG = -DMORE_24

  # more option 4: don't use the more facility at all
  # LIBS =
  # TERMFLAG = -DMORE_NONE

  # Compilation flags
  CFLAGS = -g #-static
  # On SCO Unix Development System 3.2.2a, the const type qualifier does
  # not work correctly when using cc.  The following line will cause it
  # to not be used and should be uncommented.
  # CFLAGS= -O -Dconst=
endif

##################################################################

# Source files
CSRC =	actors.c ballop.c clockr.c demons.c dgame.c dinit.c dmain.c\
	dso1.c dso2.c dso3.c dso4.c dso5.c dso6.c dso7.c dsub.c dverb1.c\
	dverb2.c gdt.c lightp.c local.c nobjs.c np.c np1.c np2.c np3.c\
	nrooms.c objcts.c rooms.c sobjs.c supp.c sverbs.c verbs.c villns.c

# Object files
OBJS =	actors.o ballop.o clockr.o demons.o dgame.o dinit.o dmain.o\
	dso1.o dso2.o dso3.o dso4.o dso5.o dso6.o dso7.o dsub.o dverb1.o\
	dverb2.o gdt.o lightp.o local.o nobjs.o np.o np1.o np2.o np3.o\
	nrooms.o objcts.o rooms.o sobjs.o supp.o sverbs.o verbs.o villns.o

dungeon: $(OBJS) dtextc.dat
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LIBS)
	@echo ""
	@echo "========================================"
	@echo "  Build complete: $(TARGET)"
	@echo "========================================"
	@echo ""
ifeq ($(PLATFORM),UNIVAC)
	@echo "Built for UNIVAC mainframe with:"
	@echo "  - No Windows dependencies"
	@echo "  - Safe string operations (strncpy)"
	@echo "  - Simplified terminal handling"
else
	@echo "Built for Unix/POSIX systems"
endif
	@echo ""
	@echo "To run the game, type: ./$(TARGET)"
	@echo ""

install: $(TARGET) dtextc.dat
	mkdir -p $(BINDIR) $(DATADIR) $(MANDIR)/man6
	cp $(TARGET) $(BINDIR)/zork
	cp dtextc.dat $(DATADIR)
	cp dungeon.6 $(MANDIR)/man6/

clean:
	rm -f $(OBJS) zork zork_univac core dsave.dat *~

# Help target
help:
	@echo "Dungeon (Zork) Makefile"
	@echo ""
	@echo "Build for different platforms:"
	@echo "  make                  - Build for Unix (default)"
	@echo "  make PLATFORM=UNIVAC  - Build for UNIVAC mainframe"
	@echo ""
	@echo "Other targets:"
	@echo "  make install          - Install the game"
	@echo "  make clean            - Remove build artifacts"
	@echo "  make help             - Show this help message"
	@echo ""

dtextc.dat:
	cat dtextc.uu1 dtextc.uu2 dtextc.uu3 dtextc.uu4 | uudecode

dinit.o: dinit.c funcs.h vars.h
	$(CC) $(CFLAGS) $(GDTFLAG) -DTEXTFILE=\"$(DATADIR)/dtextc.dat\" -c dinit.c

dgame.o: dgame.c funcs.h vars.h
	$(CC) $(CFLAGS) $(GDTFLAG) -c dgame.c

gdt.o: gdt.c funcs.h vars.h
	$(CC) $(CFLAGS) $(GDTFLAG) -c gdt.c

local.o: local.c funcs.h vars.h
	$(CC) $(CFLAGS) $(GDTFLAG) -c local.c

supp.o: supp.c funcs.h vars.h
	$(CC) $(CFLAGS) $(TERMFLAG) -c supp.c	

actors.o: funcs.h vars.h
ballop.o: funcs.h vars.h
clockr.o: funcs.h vars.h
demons.o: funcs.h vars.h
dmain.o: funcs.h vars.h
dso1.o: funcs.h vars.h
dso2.o: funcs.h vars.h
dso3.o: funcs.h vars.h
dso4.o: funcs.h vars.h
dso5.o: funcs.h vars.h
dso6.o: funcs.h vars.h
dso7.o: funcs.h vars.h
dsub.o: funcs.h vars.h
dverb1.o: funcs.h vars.h
dverb2.o: funcs.h vars.h
lightp.o: funcs.h vars.h
nobjs.o: funcs.h vars.h
np.o: funcs.h vars.h
np1.o: funcs.h vars.h parse.h
np2.o: funcs.h vars.h parse.h
np3.o: funcs.h vars.h parse.h
nrooms.o: funcs.h vars.h
objcts.o: funcs.h vars.h
rooms.o: funcs.h vars.h
sobjs.o: funcs.h vars.h
sverbs.o: funcs.h vars.h
verbs.o: funcs.h vars.h
villns.o: funcs.h vars.h
