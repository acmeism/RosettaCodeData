#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define MAX(A,B) (((A)>(B))? (A) : (B))

char * lcs(const char *a,const char * b) {
    int lena = strlen(a)+1;
    int lenb = strlen(b)+1;

    int bufrlen = 40;
    char bufr[40], *result;

    int i,j;
    const char *x, *y;
    int *la = calloc(lena*lenb, sizeof( int));
    int  **lengths = malloc( lena*sizeof( int*));
    for (i=0; i<lena; i++) lengths[i] = la + i*lenb;

    for (i=0,x=a; *x; i++, x++) {
        for (j=0,y=b; *y; j++,y++ ) {
            if (*x == *y) {
               lengths[i+1][j+1] = lengths[i][j] +1;
            }
            else {
               int ml = MAX(lengths[i+1][j], lengths[i][j+1]);
               lengths[i+1][j+1] = ml;
            }
        }
    }

    result = bufr+bufrlen;
    *--result = '\0';
    i = lena-1; j = lenb-1;
    while ( (i>0) && (j>0) ) {
        if (lengths[i][j] == lengths[i-1][j])  i -= 1;
        else if (lengths[i][j] == lengths[i][j-1]) j-= 1;
        else {
//			assert( a[i-1] == b[j-1]);
            *--result = a[i-1];
            i-=1; j-=1;
        }
    }
    free(la); free(lengths);
    return strdup(result);
}
