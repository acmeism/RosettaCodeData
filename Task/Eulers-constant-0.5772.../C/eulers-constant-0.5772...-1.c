/*********************************************
Subject: Comparing five methods for
         computing Euler's constant 0.5772...
tested : tcc-0.9.27
--------------------------------------------*/
#include <math.h>
#include <stdio.h>

#define eps 1e-6

int main(void) {
double a, b, h, n2, r, u, v;
int k, k2, m, n;

printf("From the definition, err. 3e-10\n");

n = 400;

h = 1;
for (k = 2; k <= n; k++) {
   h += 1.0 / k;
}
//faster convergence: Negoi, 1997
a = log(n +.5 + 1.0 / (24*n));

printf("Hn    %.16f\n", h);
printf("gamma %.16f\nk = %d\n\n", h - a, n);


printf("Sweeney, 1963, err. idem\n");

n = 21;

double s[] = {0, n};
r = n;
k = 1;
do {
   k += 1;
   r *= (double) n / k;
   s[k & 1] += r / k;
} while (r > eps);

printf("gamma %.16f\nk = %d\n\n", s[1] - s[0] - log(n), k);


printf("Bailey, 1988\n");

n = 5;

a = 1;
h = 1;
n2 = pow(2,n);
r = 1;
k = 1;
do {
   k += 1;
   r *= n2 / k;
   h += 1.0 / k;
   b = a; a += r * h;
} while (fabs(b - a) > eps);
a *= n2 / exp(n2);

printf("gamma %.16f\nk = %d\n\n", a - n * log(2), k);


printf("Brent-McMillan, 1980\n");

n = 13;

a = -log(n);
b = 1;
u = a;
v = b;
n2 = n * n;
k2 = 0;
k = 0;
do {
   k2 += 2*k + 1;
   k += 1;
   a *= n2 / k;
   b *= n2 / k2;
   a = (a + b) / k;
   u += a;
   v += b;
} while (fabs(a) > eps);

printf("gamma %.16f\nk = %d\n\n", u / v, k);


printf("How Euler did it in 1735\n");
//Bernoulli numbers with even indices
double B2[] = {1.0,1.0/6,-1.0/30,1.0/42,-1.0/30,\
 5.0/66,-691.0/2730,7.0/6,-3617.0/510,43867.0/798};
m = 7;
if (m > 9) return(0);

n = 10;

//n-th harmonic number
h = 1;
for (k = 2; k <= n; k++) {
   h += 1.0 / k;
}
printf("Hn    %.16f\n", h);

h -= log(n);
printf("  -ln %.16f\n", h);

//expansion C = -digamma(1)
a = -1.0 / (2*n);
n2 = n * n;
r = 1;
for (k = 1; k <= m; k++) {
   r *= n2;
   a += B2[k] / (2*k * r);
}

printf("err  %.16f\ngamma %.16f\nk = %d", a, h + a, n + m);

printf("\n\nC  =  0.57721566490153286...\n");
}
