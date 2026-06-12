#include<stdio.h>
#include<stdlib.h>

int isprime( int p ) {
    int i;
    if(p==2) return 1;
    if(!(p%2)) return 0;
    for(i=3; i*i<=p; i+=2) {
       if(!(p%i)) return 0;
    }
    return 1;
}

int main( void ) {
    int p;
    long int s = 2;
    for(p=3;p<2000000;p+=2) {
        if(isprime(p)) s+=p;
    }
    printf( "%ld\n", s );
    return 0;
}
