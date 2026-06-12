#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#define LIMIT 3000

void init_sieve(unsigned char sieve[], int limit) {
    int i, j;

    for (i = 0; i < limit; i++) {
        sieve[i] = 1;
    }
    sieve[0] = 0;
    sieve[1] = 0;

    for (i = 2; i < limit; i++) {
        if (sieve[i]) {
            for (j = i + i; j < limit; j += i) {
                sieve[j] = 0;
            }
        }
    }
}

void strange_unique_prime_triplets(unsigned char sieve[], int limit, bool verbose) {
    int count = 0, sum;
    int i, j, k, n, p;
    int pi, pj, pk;

    n = 0;
    for (i = 0; i < limit; i++) {
        if (sieve[i]) {
            n++;
        }
    }

    if (verbose) {
        printf("Strange unique prime triplets < %d:\n", limit);
    }

    for (i = 0; i + 2 < n; i++) {
        pi = 2;
        p = i;
        while (p > 0) {
            pi++;
            if (sieve[pi]) {
                p--;
            }
        }

        for (j = i + 1; j + 1 < n; j++) {
            pj = pi;
            p = j - i;
            while (p > 0) {
                pj++;
                if (sieve[pj]) {
                    p--;
                }
            }

            for (k = j + 1; k < n; k++) {
                pk = pj;
                p = k - j;
                while (p > 0) {
                    pk++;
                    if (sieve[pk]) {
                        p--;
                    }
                }

                sum = pi + pj + pk;
                if (sum < LIMIT && sieve[sum]) {
                    count++;
                    if (verbose) {
                        printf("%2d + %2d + %2d = %d\n", pi, pj, pk, sum);
                    }
                }
            }
        }
    }

    printf("Count of strange unique prime triplets < %d is %d.\n\n", limit, count);
}

int main() {
    unsigned char sieve[LIMIT];

    init_sieve(sieve, LIMIT);

    strange_unique_prime_triplets(sieve, 30, true);
    strange_unique_prime_triplets(sieve, 1000, false);

    return 0;
}
