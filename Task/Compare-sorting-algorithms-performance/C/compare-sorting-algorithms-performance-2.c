#include "csequence.h"

static double fill_constant;

void setfillconst(double c)
{
  fill_constant = c;
}

void fillwithconst(double *v, int n)
{
  while( --n >= 0 ) v[n] = fill_constant;
}

void fillwithrrange(double *v, int n)
{
  int on = n;
  while( --on >= 0 ) v[on] = n - on;
}

void shuffledrange(double *v, int n)
{
  int on = n;
  fillwithrrange(v, n);
  while( --n >= 0 ) {
    int r = rand() % on;
    double t = v[n];
    v[n] = v[r];
    v[r] = t;
  }
}
