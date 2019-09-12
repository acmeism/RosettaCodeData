#include<stdio.h>

int main ()
{
  int i;
  const char *s[] = { "%d\n", "Fizz\n", s[3] + 4, "FizzBuzz\n" };
  for (i = 1; i <= 100; i++)
    printf(s[!(i % 3) + 2 * !(i % 5)], i);
  return 0;
}
