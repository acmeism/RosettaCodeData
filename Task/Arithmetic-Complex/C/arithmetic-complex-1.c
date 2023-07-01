#include <complex.h>
#include <stdio.h>

void cprint(double complex c)
{
  printf("%f%+fI", creal(c), cimag(c));
}
void complex_operations() {
  double complex a = 1.0 + 1.0I;
  double complex b = 3.14159 + 1.2I;

  double complex c;

  printf("\na="); cprint(a);
  printf("\nb="); cprint(b);

  // addition
  c = a + b;
  printf("\na+b="); cprint(c);
  // multiplication
  c = a * b;
  printf("\na*b="); cprint(c);
  // inversion
  c = 1.0 / a;
  printf("\n1/c="); cprint(c);
  // negation
  c = -a;
  printf("\n-a="); cprint(c);
  // conjugate
  c = conj(a);
  printf("\nconj a="); cprint(c); printf("\n");
}
