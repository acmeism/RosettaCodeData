#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include <locale.h>

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

bool isCube(int n) {
    int s = (int)cbrt((double)n);
    return s*s*s == n;
}

int main() {
    const int limit = 14999;
    int i, j, p, pc = 0, gap = 1, count = 1, lastCubicSpecial = 3;
    const char *fmt = "%'7d %'7d %'6d %'4d\n";
    bool *c = sieve(limit);
    for (i = 0; i < limit; ++i) {
        if (!c[i]) ++pc;
    }
    int *primes = (int *)malloc(pc * sizeof(int));
    for (i = 0, j = 0; i < limit; ++i) {
        if (!c[i]) primes[j++] = i;
    }
    free(c);
    printf("Cubic special primes under 15,000:\n");
    printf(" Prime1  Prime2    Gap  Cbrt\n");
    setlocale(LC_NUMERIC, "");
    printf(fmt, 2, 3, 1, 1);
    for (i = 2; i < pc; ++i) {
        p = primes[i];
        gap = p - lastCubicSpecial;
        if (isCube(gap)) {
            printf(fmt, lastCubicSpecial, p, gap, (int)cbrt((double)gap));
            lastCubicSpecial = p;
            ++count;
        }
    }
    printf("\n%d such primes found.\n", count+1);
    free(primes);
    return 0;
}
