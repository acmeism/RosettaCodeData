#include <stdio.h>

#define TOTAL    988
#define Q_VALUES   8

int main() {
    const int kValues[Q_VALUES] = { 200, 100, 50, 20, 10, 5, 2, 1 };
    int t, q, iv;

    for( t=TOTAL, iv=0; iv<Q_VALUES; t%=kValues[iv], ++iv ) {
        q = t/kValues[iv];
        printf( "%4d coin%c of %4d\n", q, q!=1?'s':' ', kValues[iv] );
    }

    return 0;
}
