#include <stdio.h>

int ispr(unsigned int n) {
    if ((n & 1) == 0 || n < 2) return n == 2;
    for (unsigned int j = 3; j * j <= n; j += 2)
      if (n % j == 0) return 0; return 1; }

int main() {
  unsigned int c = 0, nc, pc = 9, i, a, b, l,
    ps[128], nxt[128];
  for (a = 0, b = 1; a < pc; a = b++) ps[a] = b;
  while (1) {
    nc = 0;
    for (i = 0; i < pc; i++) {
        if (ispr(a = ps[i]))
          printf("%8d%s", a, ++c % 5 == 0 ? "\n" : " ");
        for (b = a * 10, l = a % 10 + b++; b < l; b++)
          nxt[nc++] = b;
      }
      if (nc > 1) for(i = 0, pc = nc; i < pc; i++) ps[i] = nxt[i];
      else break;
    }
    printf("\n%d descending primes found", c);
}
