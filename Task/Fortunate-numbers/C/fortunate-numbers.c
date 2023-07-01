#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <gmp.h>

int *primeSieve(int limit, int *length) {
    int i, p, *primes;
    int j, pc = 0;
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
    for (i = 0; i < limit; ++i) {
        if (!c[i]) ++pc;
    }
    primes = (int *)malloc(pc * sizeof(int));
    for (i = 0, j = 0; i < limit; ++i) {
        if (!c[i]) primes[j++] = i;
    }
    free(c);
    *length = pc;
    return primes;
}

int compare(const void* a, const void* b) {
    int arg1 = *(const int*)a;
    int arg2 = *(const int*)b;
    if (arg1 < arg2) return -1;
    if (arg1 > arg2) return 1;
    return 0;
}

int main() {
    int i, j, f, pc, ac, limit = 379, fc = 0;
    int *primes = primeSieve(limit, &pc);
    int fortunates[80];
    mpz_t primorial, temp;
    mpz_init_set_ui(primorial, 1);
    mpz_init(temp);
    for (i = 0; i < pc; ++i) {
        mpz_mul_ui(primorial, primorial, primes[i]);
        for (j = 3; ; j += 2) {
            mpz_add_ui(temp, primorial, j);
            if (mpz_probab_prime_p(temp, 15) > 0) {
                fortunates[fc++] = j;
                break;
            }
        }
    }
    qsort(fortunates, fc, sizeof(int), compare);
    printf("After sorting, the first 50 distinct fortunate numbers are:\n");
    for (i = 0, ac = 0; ac < 50; ++i) {
       f = fortunates[i];
       if (i > 0 && f == fortunates[i-1]) continue;
       printf("%3d ", f);
       ++ac;
       if (!(ac % 10)) printf("\n");
    }
    free(primes);
    return 0;
}
