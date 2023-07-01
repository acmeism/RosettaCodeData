#include <stdio.h>
#include <gmp.h>

void jacobsthal(mpz_t r, unsigned long n) {
    mpz_t s;
    mpz_init(s);
    mpz_set_ui(r, 1);
    mpz_mul_2exp(r, r, n);
    mpz_set_ui(s, 1);
    if (n % 2) mpz_neg(s, s);
    mpz_sub(r, r, s);
    mpz_div_ui(r, r, 3);
}

void jacobsthal_lucas(mpz_t r, unsigned long n) {
    mpz_t a;
    mpz_init(a);
    mpz_set_ui(r, 1);
    mpz_mul_2exp(r, r, n);
    mpz_set_ui(a, 1);
    if (n % 2) mpz_neg(a, a);
    mpz_add(r, r, a);
}

int main() {
    int i, count;
    mpz_t jac[30], j;
    printf("First 30 Jacobsthal numbers:\n");
    for (i = 0; i < 30; ++i) {
        mpz_init(jac[i]);
        jacobsthal(jac[i], i);
        gmp_printf("%9Zd ", jac[i]);
        if (!((i+1)%5)) printf("\n");
    }

    printf("\nFirst 30 Jacobsthal-Lucas numbers:\n");
    mpz_init(j);
    for (i = 0; i < 30; ++i) {
        jacobsthal_lucas(j, i);
        gmp_printf("%9Zd ", j);
        if (!((i+1)%5)) printf("\n");
    }

    printf("\nFirst 20 Jacobsthal oblong numbers:\n");
    for (i = 0; i < 20; ++i) {
        mpz_mul(j, jac[i], jac[i+1]);
        gmp_printf("%11Zd ", j);
        if (!((i+1)%5)) printf("\n");
    }

    printf("\nFirst 20 Jacobsthal primes:\n");
    for (i = 0, count = 0; count < 20; ++i) {
        jacobsthal(j, i);
        if (mpz_probab_prime_p(j, 15) > 0) {
            gmp_printf("%Zd\n", j);
            ++count;
        }
    }

    return 0;
}
