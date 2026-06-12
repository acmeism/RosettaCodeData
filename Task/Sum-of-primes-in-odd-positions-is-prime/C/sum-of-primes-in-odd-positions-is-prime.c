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
   int s=0, p, i=1;
   for(p=2;p<=999;p++) {
       if(isprime(p)) {
           if(i%2) {
               s+=p;
               if(isprime(s)) printf( "%d       %d       %d\n", i, p, s );
           }
           i+=1;
       }
   }
   return 0;
}
