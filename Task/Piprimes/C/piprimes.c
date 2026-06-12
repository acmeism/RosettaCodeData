#include <stdio.h>
#include <stdlib.h>

int isprime( int n ) {
   int i;
        if (n<2) return 0;
   for(i=2; i*i<=n; i++) {
      if (n % i == 0) {return 0;}
   }
   return 1;
}

int main(void)  {
   int n = 0, p = 1;
   while (n<22) {
      printf( "%d   ", n );
      p++;
      if (isprime(p)) n+=1;
        }
   return 0;
}
