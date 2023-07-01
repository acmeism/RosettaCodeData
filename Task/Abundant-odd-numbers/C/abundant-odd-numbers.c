#include <stdio.h>
#include <math.h>

// The following function is for odd numbers ONLY
// Please use "for (unsigned i = 2, j; i*i <= n; i ++)" for even and odd numbers
unsigned sum_proper_divisors(const unsigned n) {
  unsigned sum = 1;
  for (unsigned i = 3, j; i < sqrt(n)+1; i += 2) if (n % i == 0) sum += i + (i == (j = n / i) ? 0 : j);
  return sum;
}

int main(int argc, char const *argv[]) {
  unsigned n, c;
  for (n = 1, c = 0; c < 25; n += 2) if (n < sum_proper_divisors(n)) printf("%u: %u\n", ++c, n);

  for ( ; c < 1000; n += 2) if (n < sum_proper_divisors(n)) c ++;
  printf("\nThe one thousandth abundant odd number is: %u\n", n);

  for (n = 1000000001 ;; n += 2) if (n < sum_proper_divisors(n)) break;
  printf("The first abundant odd number above one billion is: %u\n", n);

  return 0;
}
