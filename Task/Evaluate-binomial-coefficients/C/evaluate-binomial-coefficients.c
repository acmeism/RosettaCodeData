#include <stdio.h>
#include <limits.h>

/* We go to some effort to handle overflow situations */

static unsigned long gcd_ui(unsigned long x, unsigned long y) {
  unsigned long t;
  if (y < x) { t = x; x = y; y = t; }
  while (y > 0) {
    t = y;  y = x % y;  x = t;  /* y1 <- x0 % y0 ; x1 <- y0 */
  }
  return x;
}

unsigned long binomial(unsigned long n, unsigned long k) {
  unsigned long d, g, r = 1;
  if (k == 0) return 1;
  if (k == 1) return n;
  if (k >= n) return (k == n);
  if (k > n/2) k = n-k;
  for (d = 1; d <= k; d++) {
    if (r >= ULONG_MAX/n) {  /* Possible overflow */
      unsigned long nr, dr;  /* reduced numerator / denominator */
      g = gcd_ui(n, d);  nr = n/g;  dr = d/g;
      g = gcd_ui(r, dr);  r = r/g;  dr = dr/g;
      if (r >= ULONG_MAX/nr) return 0;  /* Unavoidable overflow */
      r *= nr;
      r /= dr;
      n--;
    } else {
      r *= n--;
      r /= d;
    }
  }
  return r;
}

int main() {
    printf("%lu\n", binomial(5, 3));
    printf("%lu\n", binomial(40, 19));
    printf("%lu\n", binomial(67, 31));
    return 0;
}
