#include <stdlib.h>
#include <math.h>
#include <stdio.h>
typedef long long int int64;
int64 gcd(int64 x, int64 y);  // helper function at end

// modulo generator function
int64 g(int64 x, int64 m) {
  return (x*x + 1) % m;
}

// the rho iteration
int64 rho(int64 n) {
  int64 x = 1;
  int64 y = x;
  int64 d = 1;
  int64 s = 0;
  int64 lim = sqrt(n);
  while (d == 1 && s < lim) {
    s += 1;
    x = g(x,n);
    y = g( g(y,n), n);
    d = gcd( abs(x-y), n);
    if (d == n)
      return 0;                 // failure
  }
  return d;                     //factor found
}

int64 main(int64 argc, char** argv) {
  int64 i = 9759463979;
  int64 p = rho(i);
  if( p == 0)
    printf("%lld: no factor found", i);
  else
    printf("%lld = %lld * %lld\n",  i, p, i/p);
}

// well-known helper function
int64 gcd(int64 x, int64 y) {
  if (x < y)
    return gcd(y, x);
  int64 t;
  while (y > 0) {
    t = x % y;
    x = y;
    y = t;
  }
  return x;
}
