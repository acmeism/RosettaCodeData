#include <gmp.h>

int main(void)
{
    mpz_t p, s;
    mpz_init_set_ui(p, 1);
    mpz_init_set_ui(s, 1);

    for (int n = 1, i = 0; i < 20; n++) {
        mpz_nextprime(s, s);
        mpz_mul(p, p, s);

        mpz_add_ui(p, p, 1);
        if (mpz_probab_prime_p(p, 25)) {
            mpz_sub_ui(p, p, 1);
            gmp_printf("%d\n", n);
            i++;
            continue;
        }

        mpz_sub_ui(p, p, 2);
        if (mpz_probab_prime_p(p, 25)) {
            mpz_add_ui(p, p, 1);
            gmp_printf("%d\n", n);
            i++;
            continue;
        }

        mpz_add_ui(p, p, 1);
    }

    mpz_clear(s);
    mpz_clear(p);
}
