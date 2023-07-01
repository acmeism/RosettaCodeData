#include <stdio.h>

unsigned chowla(const unsigned n) {
  unsigned sum = 0;
  for (unsigned i = 2, j; i * i <= n; i ++) if (n % i == 0) sum += i + (i == (j = n / i) ? 0 : j);
  return sum;
}

int main(int argc, char const *argv[]) {
  unsigned a;
  for (unsigned n = 1; n < 38; n ++) printf("chowla(%u) = %u\n", n, chowla(n));

  unsigned n, count = 0, power = 100;
  for (n = 2; n < 10000001; n ++) {
    if (chowla(n) == 0) count ++;
    if (n % power == 0) printf("There is %u primes < %u\n", count, power), power *= 10;
  }

  count = 0;
  unsigned limit = 350000000;
  unsigned k = 2, kk = 3, p;
  for ( ; ; ) {
    if ((p = k * kk) > limit) break;
    if (chowla(p) == p - 1) {
      printf("%d is a perfect number\n", p);
      count ++;
    }
    k = kk + 1; kk += k;
  }
  printf("There are %u perfect numbers < %u\n", count, limit);
  return 0;
}
