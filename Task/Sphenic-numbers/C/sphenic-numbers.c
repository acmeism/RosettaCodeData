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

void primeFactors(int n, int *factors, int *length) {
    if (n < 2) return;
    int count = 0;
    int inc[8] = {4, 2, 4, 2, 4, 6, 2, 6};
    while (!(n%2)) {
        factors[count++] = 2;
        n /= 2;
    }
    while (!(n%3)) {
        factors[count++] = 3;
        n /= 3;
    }
    while (!(n%5)) {
        factors[count++] = 5;
        n /= 5;
    }
    for (int k = 7, i = 0; k*k <= n; ) {
        if (!(n%k)) {
            factors[count++] = k;
            n /= k;
        } else {
            k += inc[i];
            i = (i + 1) % 8;
        }
    }
    if (n > 1) {
        factors[count++] = n;
    }
    *length = count;
}

int compare(const void* a, const void* b) {
    int arg1 = *(const int*)a;
    int arg2 = *(const int*)b;
    if (arg1 < arg2) return -1;
    if (arg1 > arg2) return 1;
    return 0;
}

int main() {
    const int limit = 1000000;
    int limit2 = (int)cbrt((double)limit);
    int i, j, k, pc = 0, count = 0, prod, res;
    bool *c = sieve(limit/6);
    for (i = 0; i < limit/6; ++i) {
        if (!c[i]) ++pc;
    }
    int *primes = (int *)malloc(pc * sizeof(int));
    for (i = 0, j = 0; i < limit/6; ++i) {
        if (!c[i]) primes[j++] = i;
    }
    int *sphenic = (int *)malloc(210000 * sizeof(int));
    printf("Sphenic numbers less than 1,000:\n");
    for (i = 0; i < pc-2; ++i) {
        if (primes[i] > limit2) break;
        for (j = i+1; j < pc-1; ++j) {
            prod = primes[i] * primes[j];
            if (prod * primes[j+1] >= limit) break;
            for (k = j+1; k < pc; ++k) {
                res = prod * primes[k];
                if (res >= limit) break;
                sphenic[count++] = res;
            }
        }
    }
    qsort(sphenic, count, sizeof(int), compare);
    for (i = 0; ; ++i) {
        if (sphenic[i] >= 1000) break;
        printf("%3d ", sphenic[i]);
        if (!((i+1) % 15)) printf("\n");
    }
    printf("\nSphenic triplets less than 10,000:\n");
    int tripCount = 0, s, t = 0;
    for (i = 0; i < count - 2; ++i) {
        s = sphenic[i];
        if (sphenic[i+1] == s+1 && sphenic[i+2] == s+2) {
            tripCount++;
            if (s < 9998) {
                printf("[%d, %d, %d] ", s, s+1, s+2);
                if (!(tripCount % 3)) printf("\n");
            }
            if (tripCount == 5000) t = s;
        }
    }
    setlocale(LC_NUMERIC, "");
    printf("\nThere are %'d sphenic numbers less than 1,000,000.\n", count);
    printf("There are %'d sphenic triplets less than 1,000,000.\n", tripCount);
    s = sphenic[199999];
    int factors[10], length = 0;
    primeFactors(s, factors, &length);
    printf("The 200,000th sphenic number is %'d (", s);
    for (i = 0; i < length; ++i) {
        printf("%d", factors[i]);
        if (i < length-1) printf("*");
    }
    printf(").\n");
    printf("The 5,000th sphenic triplet is [%d, %d, %d].\n", t, t+1, t+2);
    free(c);
    free(primes);
    free(sphenic);
    return 0;
}
