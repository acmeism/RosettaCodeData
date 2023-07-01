/*******************************************
Subject: Euler's constant 0.5772...
tested : tcc-0.9.27 with mpfr 4.1.0
------------------------------------------*/
#include <gmp.h>
#include <mpfr.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main (void) {
mpfr_ptr a = malloc(sizeof(__mpfr_struct));
unsigned long e2, e10;
clock_t tim = clock();

//decimal precision
e10 = 100;

//binary precision
e2 = (1 + e10) / .30103;
mpfr_init2 (a, e2);

mpfr_const_euler (a, MPFR_RNDN);
mpfr_printf ("gamma %.*Rf\n\n", e10, a);

tim = clock() - tim;
gmp_printf ("time: %.7f s\n",((double)tim)/CLOCKS_PER_SEC);
}
