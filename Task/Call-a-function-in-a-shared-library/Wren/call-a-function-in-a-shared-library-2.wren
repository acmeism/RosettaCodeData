/*
    gcc -c -fpic fakeimglib.c
    gcc -shared fakeimglib.o -o fakeimglib.so
*/
#include <stdio.h>

int openimage(const char *s) {
    static int handle = 100;
    fprintf(stderr, "opening %s\n", s);
    return handle++;
}
