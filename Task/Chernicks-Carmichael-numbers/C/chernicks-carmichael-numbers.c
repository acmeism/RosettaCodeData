#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>

typedef unsigned long long int u64;

#define TRUE 1
#define FALSE 0

int primality_pretest(u64 k) {
    if (!(k %  3) || !(k %  5) || !(k %  7) || !(k % 11) || !(k % 13) || !(k % 17) || !(k % 19) || !(k % 23)) return (k <= 23);
    return TRUE;
}

int probprime(u64 k, mpz_t n) {
    mpz_set_ui(n, k);
    return mpz_probab_prime_p(n, 0);
}

int is_chernick(int n, u64 m, mpz_t z) {
    u64 t = 9 * m;
    if (primality_pretest(6 * m + 1) == FALSE) return FALSE;
    if (primality_pretest(12 * m + 1) == FALSE) return FALSE;
    for (int i = 1; i <= n - 2; i++) if (primality_pretest((t << i) + 1) == FALSE) return FALSE;
    if (probprime(6 * m + 1, z) == FALSE) return FALSE;
    if (probprime(12 * m + 1, z) == FALSE) return FALSE;
    for (int i = 1; i <= n - 2; i++) if (probprime((t << i) + 1, z) == FALSE) return FALSE;
    return TRUE;
}

int main(int argc, char const *argv[]) {
    mpz_t z;
    mpz_inits(z, NULL);

    for (int n = 3; n <= 10; n ++) {
        u64 multiplier = (n > 4) ? (1 << (n - 4)) : 1;

        if (n > 5) multiplier *= 5;

        for (u64 k = 1; ; k++) {
            u64 m = k * multiplier;

            if (is_chernick(n, m, z) == TRUE) {
                printf("a(%d) has m = %llu\n", n, m);
                break;
            }
        }
    }

    return 0;
}
