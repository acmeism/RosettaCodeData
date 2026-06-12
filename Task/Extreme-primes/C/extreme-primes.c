#include <stdio.h>
#include <locale.h>
#include <gmp.h>

int main() {
    int i, m, extremes[30], count = 1;
    mpz_t sum, p;
    unsigned long usum, up;
    extremes[0] = 2;
    mpz_init_set_ui(sum, 2);
    mpz_init_set_ui(p, 3);
    setlocale(LC_NUMERIC, "");
    while (1) {
        mpz_add(sum, sum, p);
        if (mpz_probab_prime_p(sum, 5) > 0) {
            ++count;
            if (count <= 30) {
                extremes[count-1] = (int)mpz_get_ui(sum);
            }
            if (count == 30) {
                printf("The first 30 extreme primes are:\n");
                for (i = 0; i < 30; ++i) {
                    printf("%'7d ", extremes[i]);
                    if (!((i+1)%6)) printf("\n");
                }
                printf("\n");
            } else if (!(count % 1000)) {
                m = count / 1000;
                if (m < 6 || m == 30 || m == 40 || m == 50) {
                    usum = mpz_get_ui(sum);
                    up = mpz_get_ui(p);
                    printf("The %'6dth extreme prime is: %'18ld for p <= %'10ld\n", count, usum, up);
                    if (m == 50) break;
                }
            }
        }
        mpz_nextprime(p, p);
    }
    mpz_clear(sum);
    mpz_clear(p);
    return 0;
}
