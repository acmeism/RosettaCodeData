/**************************************************
Subject: Computation of Euler's constant 0.5772...
         with the Brent-McMillan algorithm B1,
         Math. Comp. 34 (1980), 305-312
tested : tcc-0.9.27 with gmp 6.2.0
-------------------------------------------------*/
#include <gmp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

//multi-precision float pointers
mpf_ptr u, v, k2;

//precision parameters
unsigned long e10, e2;
long e;
double f;

//log(x/y) with the Taylor series for atanh(x-y/x+y)
void ln (mpf_ptr s, unsigned long x, unsigned long y) {
mpf_ptr d = u, q = v;
unsigned long k;
   //Möbius transformation
   k = x; x -= y; y += k;

   if (x != 1) {
      printf ("ln: illegal argument x - y != 1");
      exit;
   }

   //s = 1 / (x + y)
   mpf_set_ui (s, y);
   mpf_ui_div (s, 1, s);
   //k2 = s * s
   mpf_mul (k2, s, s);
   mpf_set (d, s);

   k = 1;
   do {
      k += 2;
      //d *= k2
      mpf_mul (d, d, k2);
      //q = d / k
      mpf_div_ui (q, d, k);
      //s += q
      mpf_add (s, s, q);

      f = mpf_get_d_2exp (&e, q);
   } while (abs(e) < e2);

   //s *= 2
   mpf_mul_2exp (s, s, 1);
}

int main (void) {
mpf_ptr a = malloc(sizeof(__mpf_struct));
mpf_ptr b = malloc(sizeof(__mpf_struct));
u = malloc(sizeof(__mpf_struct));
v = malloc(sizeof(__mpf_struct));
k2 = malloc(sizeof(__mpf_struct));
//unsigned long integers
unsigned long k, n, n2, r, s, t;

clock_t tim = clock();

// n = 2^i * 3^j * 5^k

// log(n) = r * log(16/15) + s * log(25/24) + t * log(81/80)

// solve linear system for r, s, t
//  4 -3 -4| i
// -1 -1  4| j
// -1  2 -1| k

//examples
t = 1;
switch (t) {
case 1 :
   n = 60;
   r = 41;
   s = 30;
   t = 18;
//100 digits
break;
case 2 :
   n = 4800;
   r = 85;
   s = 62;
   t = 37;
//8000 digits, 0.6 s
break;
case 3 :
   n = 9375;
   r = 91;
   s = 68;
   t = 40;
//15625 digits, 2.5 s
break;
default :
   n = 18750;
   r = 98;
   s = 73;
   t = 43;
//31250 digits, 12 s. @2.00GHz
}

//decimal precision
e10 = n / .6;
//binary precision
e2 = (1 + e10) / .30103;

//initialize mpf's
mpf_set_default_prec (e2);
mpf_inits (a, b, u, v, k2, (mpf_ptr)0);

//Compute log terms

ln (b, 16, 15);

//a = r * b
mpf_mul_ui (a, b, r);

ln (b, 25, 24);

//a += s * b
mpf_mul_ui (u, b, s);
mpf_add (a, a, u);

ln (b, 81, 80);

//a += t * b
mpf_mul_ui (u, b, t);
mpf_add (a, a, u);

//gmp_printf ("log(%lu) %.*Ff\n", n, e10, a);

//B&M, algorithm B1

//a = -a, b = 1
mpf_neg (a, a);
mpf_set_ui (b, 1);
mpf_set (u, a);
mpf_set (v, b);

k = 0;
n2 = n * n;
//k2 = k * k
mpf_set_ui (k2, 0);
do {
   //k2 += 2k + 1
   mpf_add_ui (k2, k2, (k << 1) + 1);
   k += 1;

   //b = b * n2 / k2
   mpf_div (b, b, k2);
   mpf_mul_ui (b, b, n2);
   //a = (a * n2 / k + b) / k
   mpf_div_ui (a, a, k);
   mpf_mul_ui (a, a, n2);
   mpf_add (a, a, b);
   mpf_div_ui (a, a, k);

   //u += a, v += b
   mpf_add (u, u, a);
   mpf_add (v, v, b);

   f = mpf_get_d_2exp (&e, a);
} while (abs(e) < e2);

mpf_div (u, u, v);
gmp_printf ("gamma %.*Ff (maxerr. 1e-%lu)\n", e10, u, e10);

gmp_printf ("k = %lu\n\n", k);

tim = clock() - tim;
printf("time: %.7f s\n",((double)tim)/CLOCKS_PER_SEC);
}
