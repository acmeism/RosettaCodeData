# Makefile

# Edit these lines to match your JDK.
JAVA_HOME = /Library/Java/Home
CPPFLAGS = -I$(JAVA_HOME)/include
LIBS = -framework JavaVM
JAVAC = $(JAVA_HOME)/bin/javac
CC = cc

all: calljava Query.class

calljava: main.o query-jni.o
	$(CC) -o calljava main.o query-jni.o $(LIBS)

.SUFFIXES: .c .class .java .o
.c.o:
	$(CC) $(CPPFLAGS) -c $<
.java.class:
	$(JAVAC) $<

clean:
	rm -f calljava main.o query-jni.o Query.class
