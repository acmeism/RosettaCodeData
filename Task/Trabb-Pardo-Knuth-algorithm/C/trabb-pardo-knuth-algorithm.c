#include <math.h>
#include <stdio.h>

double f(double x)
{
  return sqrt(fabs(x)) + 5 * pow(x, 3);
}

int main()
{
  double inputs[11], check = 400, result;
  int i;

  printf ("\nPlease enter 11 numbers: ");
  for (i = 0; i < 11; i++)
  {
    scanf ("%lf", &inputs[i]);
  }
  printf ("\n\n\nEvaluating f(x) = |x|^0.5 + 5x^3 for the given inputs:");
  for (i = 10; i >= 0; i--)
  {
    result = f(inputs[i]);
    printf ("\nf(%lf) = ", inputs[i]);
    if (result > check)
    {
      printf ("Overflow!");
    }
    else
    {
      printf ("%lf", result);
    }
  }
  return 0;
}
