#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <gmp.h>

int lucas_lehmer(unsigned long p)
{
  mpz_t V, mp, t;
  unsigned long k, tlim;
  int res;

  if (p == 2) return 1;
  if (!(p&1)) return 0;

  mpz_init_set_ui(t, p);
  if (!mpz_probab_prime_p(t, 25)) /* if p is composite, 2^p-1 is not prime */
    { mpz_clear(t); return 0; }

  if (p < 23)                     /* trust the PRP test for these values */
    { mpz_clear(t); return (p != 11); }

  mpz_init(mp);
  mpz_setbit(mp, p);
  mpz_sub_ui(mp, mp, 1);

  /* If p=3 mod 4 and p,2p+1 both prime, then 2p+1 | 2^p-1.  Cheap test. */
  if (p > 3 && p % 4 == 3) {
    mpz_mul_ui(t, t, 2);
    mpz_add_ui(t, t, 1);
    if (mpz_probab_prime_p(t,25) && mpz_divisible_p(mp, t))
      { mpz_clear(mp); mpz_clear(t); return 0; }
  }

  /* Do a little trial division first.  Saves quite a bit of time. */
  tlim = p/2;
  if (tlim > (ULONG_MAX/(2*p)))
    tlim = ULONG_MAX/(2*p);
  for (k = 1; k < tlim; k++) {
    unsigned long q = 2*p*k+1;
    /* factor must be 1 or 7 mod 8 and a prime */
    if ( (q%8==1 || q%8==7) &&
         q % 3 && q % 5 && q % 7 &&
         mpz_divisible_ui_p(mp, q) )
      { mpz_clear(mp); mpz_clear(t); return 0; }
  }

  mpz_init_set_ui(V, 4);
  for (k = 3; k <= p; k++) {
    mpz_mul(V, V, V);
    mpz_sub_ui(V, V, 2);
    /* mpz_mod(V, V, mp) but more efficiently done given mod 2^p-1 */
    if (mpz_sgn(V) < 0) mpz_add(V, V, mp);
    /* while (n > mp) { n = (n >> p) + (n & mp) } if (n==mp) n=0 */
    /* but in this case we can have at most one loop plus a carry */
    mpz_tdiv_r_2exp(t, V, p);
    mpz_tdiv_q_2exp(V, V, p);
    mpz_add(V, V, t);
    while (mpz_cmp(V, mp) >= 0) mpz_sub(V, V, mp);
  }
  res = !mpz_sgn(V);
  mpz_clear(t); mpz_clear(mp); mpz_clear(V);
  return res;
}

int main(int argc, char* argv[]) {
  unsigned long i, n = 43112609;
  if (argc >= 2) n = strtoul(argv[1], 0, 10);
  for (i = 1; i <= n; i++) {
    if (lucas_lehmer(i)) {
      printf("M%lu ", i);
      fflush(stdout);
    }
  }
  printf("\n");
  return 0;
}
