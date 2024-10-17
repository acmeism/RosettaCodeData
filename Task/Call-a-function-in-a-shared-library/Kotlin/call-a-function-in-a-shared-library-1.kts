#include <stdio.h>
/* gcc -shared -fPIC -nostartfiles fakeimglib.c -o fakeimglib.so */
int openimage(const char *s)
{
    static int handle = 100;
    fprintf(stderr, "opening %s\n", s);
    return handle++;
}
