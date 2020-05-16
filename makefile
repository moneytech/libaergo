ifneq ($(OS_NAME),)
	TARGET_OS = $(OS_NAME)
else
	ifeq ($(OS),Windows_NT)
		TARGET_OS = Windows
	else ifeq ($(PLATFORM),iPhoneOS)
		TARGET_OS = iPhoneOS
	else ifeq ($(PLATFORM),iPhoneSimulator)
		TARGET_OS = iPhoneSimulator
	else
		UNAME_S := $(shell uname -s)
		ifeq ($(UNAME_S),Darwin)
			TARGET_OS = Mac
		else
			TARGET_OS = Linux
		endif
	endif
endif

ifeq ($(TARGET_OS),Windows)
	IMPLIB   := aergo-0.1
	LIBRARY  := aergo-0.1.dll
	WINLIB   := $(IMPLIB).lib
	LDFLAGS  := $(LDFLAGS) -static-libgcc -static-libstdc++
else ifeq ($(TARGET_OS),iPhoneOS)
	LIBRARY = libaergo.dylib
	CFLAGS += -fPIC
else ifeq ($(TARGET_OS),iPhoneSimulator)
	LIBRARY = libaergo.dylib
	CFLAGS += -fPIC
else
	ifeq ($(TARGET_OS),Mac)
		LIBRARY  = libaergo.0.dylib
		LIBNICK  = libaergo.dylib
		INSTNAME = $(LIBPATH)/$(LIBNICK)
		CURR_VERSION   = 0.1.0
		COMPAT_VERSION = 0.1.0
	else
		LIBRARY  = libaergo.so.0.1
		LIBNICK  = libaergo.so
		SONAME   = $(LIBNICK2)
	endif
	IMPLIB   = aergo
	prefix  ?= /usr/local
	LIBPATH  = $(prefix)/lib
	INCPATH  = $(prefix)/include
	EXEPATH  = $(prefix)/bin
	CFLAGS  += -fPIC
endif

LDLIBS  = -lsecp256k1-vrf


CC    ?= gcc
STRIP ?= strip
AR    ?= ar


all: $(LIBRARY) static

static: libaergo.a


aergo.o:
	$(CC) -c  aergo.c  -Inanopb -std=c99 -Wno-pointer-sign


libaergo.a: aergo.o
	$(AR) rcs $@ $^


# Linux / Unix
libaergo.so.0.1: aergo.o
	$(CC) -shared -Wl,-soname,$(SONAME)  -o $@  $^  $(LDLIBS) $(LDFLAGS)
	$(STRIP) $@
	ln -sf $(LIBRARY) $(LIBNICK)

# OSX
libaergo.0.dylib: aergo.o
	$(CC) -dynamiclib -install_name "$(INSTNAME)" -current_version $(CURR_VERSION) -compatibility_version $(COMPAT_VERSION)  -o $@  $^  $(LDLIBS) $(LDFLAGS)
	$(STRIP) -x $@
	ln -sf $(LIBRARY) $(LIBNICK)

# iOS
libaergo.dylib: aergo.o
	$(CC) -dynamiclib  -o $@  $^  $(LDLIBS) $(LDFLAGS)
	$(STRIP) -x $@

# Windows
aergo-0.1.dll: aergo.o
	$(CC) -shared  -o $@  $^  -Wl,--out-implib,$(IMPLIB).lib $(LDLIBS) $(LDFLAGS) -lws2_32
	$(STRIP) $@


install:
	mkdir -p $(LIBPATH)
	cp $(LIBRARY) $(LIBPATH)
	cd $(LIBPATH) && ln -sf $(LIBRARY) $(LIBNICK)
	#cp aergo.h $(INCPATH)

clean:
	rm -f *.o *.a $(LIBNICK) $(LIBRARY)