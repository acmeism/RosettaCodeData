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

int prime( int n ) {
    int p, pn=1;
    if(n==1) return 2;
    for(p=3;pn<n;p+=2) {
        if(isprime(p)) pn++;
    }
    return p-2;
}

int main(void) {
    printf( "%d\n", prime(10001) );
    return 0;
}
