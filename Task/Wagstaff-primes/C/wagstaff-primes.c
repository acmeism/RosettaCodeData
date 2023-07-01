#include <stdio.h>
#include <string.h>
#include <gmp.h>

int main() {
    const int limit = 29;
    int count = 0;
    char tmp[40];
    mpz_t p, w;
    mpz_init_set_ui(p, 1);
    mpz_init(w);
    while (count < limit) {
       mpz_nextprime(p, p);
       mpz_set_ui(w, 1);
       unsigned long ulp = mpz_get_ui(p);
       mpz_mul_2exp(w, w, ulp);
       mpz_add_ui(w, w, 1);
       mpz_tdiv_q_ui(w, w, 3);
       if (mpz_probab_prime_p(w, 15) > 0) {
          ++count;
          char *ws = mpz_get_str(NULL, 10, w);
          size_t le = strlen(ws);
          if (le < 34) {
              strcpy(tmp, ws);
          } else {
              strncpy(tmp, ws, 15);
              strcpy(tmp + 15, "...");
              strncpy(tmp + 18, ws + le - 15, 16);
          }
          printf("%5lu: %s", ulp, tmp);
          if (le >=34) printf( " (%ld digits)", le);
          printf("\n");
       }
    }
    return 0;
}
