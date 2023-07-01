/*
 * Rosetta Code - stream merge in C.
 *
 * Two streams (text files) with integer numbers, C89, Visual Studio 2010.
 *
 */

#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>

#define GET(N) { if(fscanf(f##N,"%d",&b##N ) != 1) f##N = NULL; }
#define PUT(N) { printf("%d\n", b##N); GET(N) }

void merge(FILE* f1, FILE* f2, FILE* out)
{
    int b1;
    int b2;

    if(f1) GET(1)
    if(f2) GET(2)

    while ( f1 && f2 )
    {
        if ( b1 <= b2 ) PUT(1)
        else            PUT(2)
    }
    while (f1 ) PUT(1)
    while (f2 ) PUT(2)
}

int main(int argc, char* argv[])
{
    if ( argc < 3 || argc > 3 )
    {
        puts("streammerge filename1 filename2");
        exit(EXIT_FAILURE);
    }
    else
        merge(fopen(argv[1],"r"),fopen(argv[2],"r"),stdout);

    return EXIT_SUCCESS;
}
