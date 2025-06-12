/* Magic constant */
#include<stdio.h>
#include<math.h>

/* returns the magic constant of a magic square of order n + 2 */
long a(int n)
{
  long n2 = n + 2;
  return (n2 * ((n2 * n2) + 1)) / 2;
}

/* returns the order of the magic square whose magic constant is at least x */
long inv_a(double x)
{
  return (long)pow((2. * x), 1. / 3.) + 1;
}

int main()
{
  int n;
  double e = 1.; /* final values can be greater than MAX_LONG */
  printf("The first 20 magic constants are ");
  for (n = 1; n <= 20; n++)
    printf("%d ", a(n));
  printf("\n");
  printf("The 1,000th magic constant is %d\n", a(1000));
  for (n = 1; n <= 20; n++)
  {
    e *= 10;
    printf("10^%2d: %9d\n", n, inv_a(e));
  }
}
