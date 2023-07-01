# jfe makefile info
# customize to create makefile suitable for your platform
# 32bit builds on 64bit systems require -m32 in CFLAGS and FLAGS
# Unix requires -ldl  in FLAGS and Windows does not

CPPFLAGS= -I/usr/local/j64-602/system/examples/jfe
CFLAGS= -O0 -g
LOADLIBES= -ldl

main: main.o Query.o
