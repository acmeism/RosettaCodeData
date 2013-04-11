#include <stdio.h>
#include <math.h>
#include <complex.h>

void roots_quadratic_eq(double a, double b, double c, complex double *x)
{
  double delta;

  delta = b*b - 4.0*a*c;
  x[0] = (-b + csqrt(delta)) / (2.0*a);
  x[1] = (-b - csqrt(delta)) / (2.0*a);
}
