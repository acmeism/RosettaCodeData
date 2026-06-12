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
    int i=3, j=5, champ=3, champj=5, record=2;
    for(i=3;j<=1000000;i=j) {
        j=nextprime(i);
        if(j-i>record) {
            champ=i;
            champj=j;
            record = j-i;
        }
    }
    printf( "The largest difference was %d, between %d and %d.\n", record, champ, champj );
    return 0;
}
