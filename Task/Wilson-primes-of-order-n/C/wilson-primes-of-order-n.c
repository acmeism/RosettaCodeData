#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <gmp.h>

bool *sieve(int limit) {
    int i, p;
    limit++;
    // True denotes composite, false denotes prime.
    bool *c = calloc(limit, sizeof(bool)); // all false by default
    c[0] = true;
    c[1] = true;
    for (i = 4; i < limit; i += 2) c[i] = true;
    p = 3; // Start from 3.
    while (true) {
        int p2 = p * p;
        if (p2 >= limit) break;
        for (i = p2; i < limit; i += 2 * p) c[i] = true;
        while (true) {
            p += 2;
            if (!c[p]) break;
        }
    }
    return c;
}

int main() {
    const int limit = 11000;
    int i, j, n, pc = 0;
    unsigned long p;
    bool *c = sieve(limit);
    for (i = 0; i < limit; ++i) {
        if (!c[i]) ++pc;
    }
    unsigned long *primes = (unsigned long *)malloc(pc * sizeof(unsigned long));
    for (i = 0, j = 0; i < limit; ++i) {
        if (!c[i]) primes[j++] = i;
    }
    mpz_t *facts = (mpz_t *)malloc(limit *sizeof(mpz_t));
    for (i = 0; i < limit; ++i) mpz_init(facts[i]);
    mpz_set_ui(facts[0], 1);
    for (i = 1; i < limit; ++i) mpz_mul_ui(facts[i], facts[i-1], i);
    mpz_t f, sign;
    mpz_init(f);
    mpz_init_set_ui(sign, 1);
    printf(" n:  Wilson primes\n");
    printf("--------------------\n");
    for (n = 1; n < 12; ++n) {
        printf("%2d:  ", n);
        mpz_neg(sign, sign);
        for (i = 0; i < pc; ++i) {
            p = primes[i];
            if (p < n) continue;
            mpz_mul(f, facts[n-1], facts[p-n]);
            mpz_sub(f, f, sign);
            if (mpz_divisible_ui_p(f, p*p)) printf("%ld ", p);
        }
        printf("\n");
    }
    free(c);
    free(primes);
    for (i = 0; i < limit; ++i) mpz_clear(facts[i]);
    free(facts);
    return 0;
}
