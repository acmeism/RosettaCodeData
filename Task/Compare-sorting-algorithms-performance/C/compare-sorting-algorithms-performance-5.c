#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "polifitgsl.h"

#define MAXNUMOFDATA 100

double x[MAXNUMOFDATA], y[MAXNUMOFDATA];
double cf[2];

int main()
{
  int i, nod;
  int r;

  for(i=0; i < MAXNUMOFDATA; i++)
  {
    r = scanf("%lf %lf\n", &x[i], &y[i]);
    if ( (r == EOF) || (r < 2) ) break;
    x[i] = log10(x[i]);
    y[i] = log10(y[i]);
  }
  nod = i;

  polynomialfit(nod, 2, x, y, cf);
  printf("C0 = %lf\nC1 = %lf\n", cf[0], cf[1]);

  return 0;
}
