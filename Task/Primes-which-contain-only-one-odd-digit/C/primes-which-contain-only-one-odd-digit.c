#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define LIMIT 1000
#define STRETCH_LIMIT 1000000

/*
*  return the number of odd digits in the decimal
*  representation of n
*/
int odd_digits(int n) {
  int digit, count;
  count = 0;
  while (n > 0) {
    digit = n % 10;
    if ((digit & 1) == 1) count++;
    n /= 10;
  }
  return count;
}


bool isprime(int n) {
  int i;
  if (n < 2) return false;
  if ((n & 1) == 0) return (n == 2);
  for (i = 3; i * i <= n; i += 2) {
    if (n % i == 0) return false;
  }
  return true;
}

int main(void) {
  int i, found;
  printf("Searching to %d for primes with only 1 odd digit:\n", LIMIT);
  found = 0;
  for (i = 3; i < LIMIT; i += 2) {
    if (isprime(i) && odd_digits(i) == 1) {
      printf("%6d", i);
      if (++found % 8 == 0) printf("\n");
    }
  }
  printf("\n%d were found\n", found);

  /* tackle the stretch goal */
  found = 0;
  for (i = 3; i < STRETCH_LIMIT; i += 2)
    if (isprime(i) && odd_digits(i) == 1) found++;
  printf("And below %d there are %d\n", STRETCH_LIMIT, found);
  return EXIT_SUCCESS;
}
