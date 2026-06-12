#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <gmp.h>

void firstOneTwo(mpz_t res, int n) {
    char *s;
    bool found = false;
    mpz_t k, r, m, t, one, nine;
    mpz_inits(k, r, m, t, one, nine, NULL);
    mpz_set_ui(one, 1);
    mpz_set_ui(nine, 9);
    mpz_set_ui(k, 10);
    mpz_pow_ui(k, k, n);
    mpz_sub_ui(k, k, 1);
    mpz_tdiv_q(k, k, nine);
    mpz_mul_2exp(r, one, n);
    mpz_sub_ui(r, r, 1);
    while (mpz_cmp(m, r) <= 0) {
        s = mpz_get_str(NULL, 2, m);
        mpz_set_str(t, s, 10);
        mpz_add(t, k, t);
        if (mpz_probab_prime_p(t, 15) > 0) {
            found = true;
            break;
        }
        mpz_add_ui(m, m, 1);
    }
    if (!found) mpz_set_si(t, -1);
    mpz_set(res, t);
    mpz_clears(k, r, m, t, one, nine, NULL);
}

int main() {
    int n, ix;
    char *s;
    mpz_t res;
    mpz_init(res);
    for (n = 1; n < 21; ++n) {
        firstOneTwo(res, n);
        gmp_printf("%4d: %Zd\n", n, res);
    }
    for (n = 100; n <= 2000; n += 100) {
        firstOneTwo(res, n);
        if (!mpz_cmp_si(res, -1)) {
            printf("No %d-digit prime found with only digits 1 or 2.", n);
        } else {
            s = mpz_get_str(NULL, 10, res);
            ix = strchr(s, '2') - s;
            printf("%4d: (1 x %4d) %s\n", n, ix, s + ix);
        }
    }
    mpz_clear(res);
    return 0;
}
