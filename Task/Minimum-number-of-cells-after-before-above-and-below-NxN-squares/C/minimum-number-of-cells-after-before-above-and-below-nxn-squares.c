#include<stdio.h>
#include<stdlib.h>

#define min(a, b) (a<=b?a:b)

void minab( unsigned int n ) {
    int i, j;
    for(i=0;i<n;i++) {
        for(j=0;j<n;j++) {
            printf( "%2d  ", min( min(i, n-1-i), min(j, n-1-j) ));
        }
        printf( "\n" );
    }
    return;
}

int main(void) {
    minab(10);
    return 0;
}
