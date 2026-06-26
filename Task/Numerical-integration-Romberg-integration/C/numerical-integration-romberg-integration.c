#include <stdio.h>
#include <math.h>

#define LOWER  -3.0                 /* Lower bound of integration */
#define UPPER   3.0                 /* Upper bound of integration */
#define MAX     12                  /* Maximum number of iterations */
#define SIZE    MAX + 1             /* Array size (allowing for 1 based array indexing) */
#define LIMIT   5e-12               /* Convergence tolerance */

typedef double (*operator_fn)(double);

double Fn(double x)                 /* Function to be integrated */
{
   /** return sin(x);               /* f(x) = sin(x) */
   /** return 1.0 / x;              /* f(x) = 1 / x  */
   return exp(x);                   /* f(x) = exp(x) */
}

double romberg(operator_fn op, double a, double b, int max) {
   double R[SIZE][SIZE];
   double h;                        /* Step size for current refinement */
   double s0;                       /* f(a) + f(b), reused each iteration */
   double s;                        /* Running sum of interior points */
   double f;                        /* Richardson scaling factor (4^k) */
   double d;                        /* Difference between estimates */
   int i, j, k, n;                  /* Loop counters */

   h  = b - a;                      /* Initial step size */
   s0 = op(a) + op(b);              /* Initial endpoint sum */
   n  = 1;                          /* Initial number of intervals = 2^i */

   i = 0;
   R[0][0] = s0 * h / 2.0;          /* First trapezoid */

   do
   {
      i++;                          /* Number of iterations */
      n *= 2;                       /* Double number of intervals */
      h /= 2.0;                     /*  New step size */

      s = s0 / 2.0;                 /* Start with half of f(a)+f(b) */
      for (j = 1; j <= n - 1; ++j)  /* Compute interior points */
         s += op(a + j * h);

      R[i][0] = s * h;              /* Initial estimate */

      f = 1.0;
      for (k = 1; k <= i; ++k)      /* Find Richardson extrapolation  */
      {                             /* R[i,k] = (4^k * R[i,k-1] - R[i-1,k-1]) / (4^k - 1) */
         f *= 4.0;                  /* f = 4, 16, 64, ... */
         R[i][k] = (f * R[i][k - 1] - R[i - 1][k - 1]) / (f - 1.0);
      }

      d = fabs(R[i][i] - R[i - 1][i - 1]);
      printf("I=%2d    R= %22.15f\n", i, R[i][i]);

   }
   while (i < max && d >= LIMIT);   /* Stop when max iterations or limit reached */

   printf("\n");
   if (i < max)
      printf("Converged early at I=%2d\n", i);
   else
      printf("Max iterations reached\n");

   return R[i][i];
}

int main(void) {
   double a = LOWER;
   double b = UPPER;
   double r = romberg(Fn, a, b, MAX);
   printf("Integral = %22.15f\n", r);
   return 0;
}
