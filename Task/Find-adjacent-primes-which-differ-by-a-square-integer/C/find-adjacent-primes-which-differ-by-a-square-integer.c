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

int issquare( int p ) {
    int i;
    for(i=0;i*i<p;i++);
    return i*i==p;
}

int main(void) {
    int i=3, j=2;
    for(i=3;j<=1000000;i=j) {
        j=nextprime(i);
        if(j-i>36&&issquare(j-i)) printf( "%d %d %d\n", i, j, j-i );
    }
    return 0;
}
