$ make main.o
cc    -c -o main.o main.c
$ D=$( dirname $( which python3 ) )
$ gcc $( $D/python3.2-config --cflags ) -c Query.c
In file included from /usr/include/python3.2mu/Python.h:8:0,
                 from Q.c:18:
/usr/include/python3.2mu/pyconfig.h:1173:0: warning: "_POSIX_C_SOURCE" redefined [enabled by default]
/usr/include/features.h:214:0: note: this is the location of the previous definition
$ gcc -o main main.o Query.o $( $D/python3.2-config --ldflags )
$ ./main
Here am I
$
