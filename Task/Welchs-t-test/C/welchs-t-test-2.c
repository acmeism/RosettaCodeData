#include <stdio.h>
#include <math.h>

long double lngammal(const double xx) {
   unsigned int j;
   double x,y,tmp,ser;
   const double cof[6] = {
      76.18009172947146,    -86.50532032941677,
      24.01409824083091,    -1.231739572450155,
      0.1208650973866179e-2,-0.5395239384953e-5
   };

   y = x = xx;
   tmp = x + 5.5 - (x + 0.5) * logl(x + 5.5);
   ser = 1.000000000190015;
   for (j=0;j<=5;j++)
      ser += (cof[j] / ++y);
   return(log(2.5066282746310005 * ser / x) - tmp);
}

