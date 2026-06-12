#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define TRUE 1
#define FALSE 0

typedef int bool;

void primeSieve(int *c, int limit, bool processEven, bool primesOnly) {
    int i, ix, p, p2;
    limit++;
    c[0] = TRUE;
    c[1] = TRUE;
    if (processEven) {
        for (i = 4; i < limit; i +=2) c[i] = TRUE;
    }
    p = 3;
    while (TRUE) {
        p2 = p * p;
        if (p2 >= limit) break;
        for (i = p2; i < limit; i += 2*p) c[i] = TRUE;
        while (TRUE) {
            p += 2;
            if (!c[p]) break;
        }
    }
    if (primesOnly) {
        /* move the actual primes to the front of the array */
        c[0] = 2;
        for (i = 3, ix = 1; i < limit; i += 2) {
            if (!c[i]) c[ix++] = i;
        }
    }
}

int main() {
    int i, p, hp, n = 10000000;
    int limit = (int)(log(n) * (double)n * 1.2);  /* should be more than enough */
    int *primes = (int *)calloc(limit, sizeof(int));
    primeSieve(primes, limit-1, FALSE, TRUE);
    printf("The first 20 pairs of natural numbers whose sum is prime are:\n");
    for (i = 1; i <= 20; ++i) {
        p = primes[i];
        hp = p / 2;
        printf("%2d + %2d = %2d\n", hp, hp+1, p);
    }
    printf("\nThe 10 millionth such pair is:\n");
    p = primes[n];
    hp = p / 2;
    printf("%2d + %2d = %2d\n", hp, hp+1, p);
    free(primes);
    return 0;
}
