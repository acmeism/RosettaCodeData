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

int nextprime( int p ) {
    int i=0;
    if(p==0) return 2;
    if(p<3) return p+1;
    while(!isprime(++i + p));
    return i+p;
}

int main(void) {
    int p1, p2;
    for(p1=3;p1<=99;p1+=2) {
        p2=nextprime(p1);
        if(p2<100&&isprime(p1)&&isprime(p2+p1-1)) {
            printf( "%d + %d - 1 = %d\n", p1, p2, p1+p2-1 );
        }
    }
    return 0;
}
