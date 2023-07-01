#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define TRUE 1
#define FALSE 0
#define TRILLION 1000000000000

typedef unsigned char bool;
typedef unsigned long long uint64;

void sieve(uint64 limit, uint64 *primes, uint64 *length) {
    uint64 i, count, p, p2;
    bool *c = calloc(limit + 1, sizeof(bool));  /* composite = TRUE */
    primes[0] = 2;
    count  = 1;
    /* no need to process even numbers > 2 */
    p = 3;
    for (;;) {
        p2 = p * p;
        if (p2 > limit) break;
        for (i = p2; i <= limit; i += 2 * p) c[i] = TRUE;
        for (;;) {
            p += 2;
            if (!c[p]) break;
        }
    }
    for (i = 3; i <= limit; i += 2) {
        if (!c[i]) primes[count++] = i;
    }
    *length = count;
    free(c);
}

void squareFree(uint64 from, uint64 to, uint64 *results, uint64 *len) {
    uint64 i, j, p, p2, np, count = 0, limit = (uint64)sqrt((double)to);
    uint64 *primes = malloc((limit + 1) * sizeof(uint64));
    bool add;
    sieve(limit, primes, &np);
    for (i = from; i <= to; ++i) {
        add = TRUE;
        for (j = 0; j < np; ++j) {
            p = primes[j];
            p2 = p * p;
            if (p2 > i) break;
            if (i % p2 == 0) {
                add = FALSE;
                break;
            }
        }
        if (add) results[count++] = i;
    }
    *len = count;
    free(primes);
}

int main() {
    uint64 i, *sf, len;
    /* allocate enough memory to deal with all examples */
    sf = malloc(1000000 * sizeof(uint64));
    printf("Square-free integers from 1 to 145:\n");
    squareFree(1, 145, sf, &len);
    for (i = 0; i < len; ++i) {
        if (i > 0 && i % 20 == 0) {
            printf("\n");
        }
        printf("%4lld", sf[i]);
    }

    printf("\n\nSquare-free integers from %ld to %ld:\n", TRILLION, TRILLION + 145);
    squareFree(TRILLION, TRILLION + 145, sf, &len);
    for (i = 0; i < len; ++i) {
        if (i > 0 && i % 5 == 0) {
            printf("\n");
        }
        printf("%14lld", sf[i]);
    }

    printf("\n\nNumber of square-free integers:\n");
    int a[5] = {100, 1000, 10000, 100000, 1000000};
    for (i = 0; i < 5; ++i) {
        squareFree(1, a[i], sf, &len);
        printf("  from %d to %d = %lld\n", 1, a[i], len);
    }
    free(sf);
    return 0;
}
