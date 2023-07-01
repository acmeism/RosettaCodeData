# Makefile

# Edit the next lines to match your JDK.
JAVA_HOME = /usr/local/jdk-1.8.0
CPPFLAGS = -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/openbsd
JAVAC = $(JAVA_HOME)/bin/javac
JAVAH = $(JAVA_HOME)/bin/javah

CC = cc
LDFLAGS = -shared -fPIC
LIB = libTrySort.so

all: TrySort.class $(LIB)

$(LIB): TrySort.c TrySort.h
	$(CC) $(CPPFLAGS) $(LDFLAGS) -o $@ TrySort.c

.SUFFIXES: .class .java .h
.class.h:
	rm -f $@
	$(JAVAH) -jni -o $@ $(<:.class=)
.java.class:
	$(JAVAC) $<

clean:
	rm -f TrySort.class TrySort?IntList.class \
	    TrySort?ReverseAbsCmp.class TrySort.h $(LIB)
