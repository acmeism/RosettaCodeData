#include <stdio.h>

#include "polifitgsl.h"

#define NP 11
double x[] = {0,  1,  2,  3,  4,  5,  6,   7,   8,   9,   10};
double y[] = {1,  6,  17, 34, 57, 86, 121, 162, 209, 262, 321};

#define DEGREE 3
double coeff[DEGREE];

int main()
{
  int i;

  polynomialfit(NP, DEGREE, x, y, coeff);
  for(i=0; i < DEGREE; i++) {
    printf("%lf\n", coeff[i]);
  }
  return 0;
}
