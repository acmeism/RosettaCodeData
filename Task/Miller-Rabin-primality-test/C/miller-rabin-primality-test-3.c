#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <gmp.h>
#include "miller-rabin.h"

#define PREC 10
#define TOP  4000

int main()
{
  mpz_t num;

  mpz_init(num);
  mpz_set_ui(num, 1);

  while ( mpz_cmp_ui(num, TOP) < 0 ) {
    if ( miller_rabin_test(num, PREC) ) {
      gmp_printf("%Zd maybe prime\n", num);
    } /*else {
      gmp_printf("%Zd not prime\n", num);
      }*/ // remove the comment iff you're interested in
          // sure non-prime.
    mpz_add_ui(num, num, 1);
  }

  mpz_clear(num);
  return EXIT_SUCCESS;
}
