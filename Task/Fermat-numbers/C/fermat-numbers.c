#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>

void mpz_factors(mpz_t n) {
  int factors = 0;
  mpz_t s, m, p;
  mpz_init(s), mpz_init(m), mpz_init(p);

  mpz_set_ui(m, 3);
  mpz_set(p, n);
  mpz_sqrt(s, p);

  while (mpz_cmp(m, s) < 0) {
    if (mpz_divisible_p(p, m)) {
      gmp_printf("%Zd ", m);
      mpz_fdiv_q(p, p, m);
      mpz_sqrt(s, p);
      factors ++;
    }
    mpz_add_ui(m, m, 2);
  }

  if (factors == 0) printf("PRIME\n");
  else gmp_printf("%Zd\n", p);
}

int main(int argc, char const *argv[]) {
  mpz_t fermat;
  mpz_init_set_ui(fermat, 3);
  printf("F(0) = 3 -> PRIME\n");
  for (unsigned i = 1; i < 10; i ++) {
    mpz_sub_ui(fermat, fermat, 1);
    mpz_mul(fermat, fermat, fermat);
    mpz_add_ui(fermat, fermat, 1);
    gmp_printf("F(%d) = %Zd -> ", i, fermat);
    mpz_factors(fermat);
  }

  return 0;
}
