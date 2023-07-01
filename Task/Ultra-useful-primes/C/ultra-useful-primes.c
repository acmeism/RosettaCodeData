#include <stdio.h>
#include <gmp.h>

int a(unsigned int n) {
    int k;
    mpz_t p;
    mpz_init_set_ui(p, 1);
    mpz_mul_2exp(p, p, 1 << n);
    mpz_sub_ui(p, p, 1);
    for (k = 1; ; k += 2) {
        if (mpz_probab_prime_p(p, 15) > 0) return k;
        mpz_sub_ui(p, p, 2);
    }
}

int main() {
    unsigned int n;
    printf(" n   k\n");
    printf("----------\n");
    for (n = 1; n < 15; ++n) printf("%2d   %d\n", n, a(n));
    return 0;
}
