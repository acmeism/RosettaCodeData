#include<stdio.h>
#include<stdlib.h>
#include<math.h>

int isprime( int p ) {
    int i;
    if(p==2) return 1;
    if(!(p%2)) return 0;
    for(i=3; i*i<=p; i+=2) {
       if(!(p%i)) return 0;
    }
    return 1;
}

int main(void) {
    int np = 1, d, i, n;
    printf( "3  " );
    for(d=1; d<6; d++) {
        for(i=3; i<pow(10,d)-1; i+=10) {
            n = i + 3*pow(10,d);
            if(isprime(n)) {
                ++np;
                if(n<4009) {
                    printf("%d  ",n);
                    if(!(np%10)) printf("\n");
                }
            }
        }
    }
    printf( "\n\nThere were %d primes of the form 3x3 below one million.\n", np );
    return 0;
}
