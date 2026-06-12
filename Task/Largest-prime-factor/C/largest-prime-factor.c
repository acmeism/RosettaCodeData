#include <stdio.h>
#include <stdlib.h>

int isprime( long int n ) {
    int i=3;
    if(!(n%2)) return 0;
    while( i*i < n ) {
        if(!(n%i)) return 0;
        i+=2;
    }
    return 1;
}

int main(void) {
    long int n=600851475143, j=3;

    while(!isprime(n)) {
        if(!(n%j)) n/=j;
        j+=2;
    }
    printf( "%ld\n", n );
    return 0;
}
