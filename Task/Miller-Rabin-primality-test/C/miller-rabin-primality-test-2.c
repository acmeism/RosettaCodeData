#include <stdbool.h>
#include <gmp.h>
#include "primedecompose.h"

#define MAX_DECOMPOSE 100

bool miller_rabin_test(mpz_t n, int j)
{
  bool res;
  mpz_t f[MAX_DECOMPOSE];
  mpz_t s, d, a, x, r;
  mpz_t n_1, n_3;
  gmp_randstate_t rs;
  int l=0, k;

  res = false;
  gmp_randinit_default(rs);

  mpz_init(s); mpz_init(d);
  mpz_init(a); mpz_init(x); mpz_init(r);
  mpz_init(n_1); mpz_init(n_3);

  if ( mpz_cmp_si(n, 3) <= 0 ) { // let us consider 1, 2, 3 as prime
    gmp_randclear(rs);
    return true;
  }
  if ( mpz_odd_p(n) != 0 ) {
    mpz_sub_ui(n_1, n, 1);         //  n-1
    mpz_sub_ui(n_3, n, 3);         //  n-3
    l = decompose(n_1, f);
    mpz_set_ui(s, 0);
    mpz_set_ui(d, 1);
    for(k=0; k < l; k++) {
      if ( mpz_cmp_ui(f[k], 2) == 0 )
	mpz_add_ui(s, s, 1);
      else
	mpz_mul(d, d, f[k]);
    }                             // 2^s * d = n-1
    while(j-- > 0) {
      mpz_urandomm(a, rs, n_3);     // random from 0 to n-4
      mpz_add_ui(a, a, 2);          // random from 2 to n-2
      mpz_powm(x, a, d, n);
      if ( mpz_cmp_ui(x, 1) == 0 ) continue;
      mpz_set_ui(r, 0);
      while( mpz_cmp(r, s) < 0 ) {
	if ( mpz_cmp(x, n_1) == 0 ) break;
	mpz_powm_ui(x, x, 2, n);
	mpz_add_ui(r, r, 1);
      }
      if ( mpz_cmp(x, n_1) == 0 ) continue;
      goto flush; // woops
    }
    res = true;
  }

flush:
  for(k=0; k < l; k++) mpz_clear(f[k]);
  mpz_clear(s); mpz_clear(d);
  mpz_clear(a); mpz_clear(x); mpz_clear(r);
  mpz_clear(n_1); mpz_clear(n_3);
  gmp_randclear(rs);
  return res;
}
