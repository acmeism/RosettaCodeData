#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
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

typedef struct {
    char digs[20];
    int count;
} digits;

digits getDigits(int n) {
    if (n == 0) return (digits){ {0}, 1 };
    digits d;
    d.count = 0;
    while (n > 0) {
        d.digs[d.count++] = n % 10;
        n = n / 10;
    }
    return d; // note digits are in reverse order
}

typedef struct {
    int x;
    int y;
} pair;

int main() {
    const int limit = 1000000000;
    int i, j, k, pc = 0, count = 0, count2 = 0, p1, p2, key1, key2;
    digits d;
    bool *c = sieve(limit);
    for (i = 0; i < limit; ++i) {
        if (!c[i]) ++pc;
    }
    int *primes = (int *)malloc(pc * sizeof(int));
    for (i = 0, j = 0; i < limit; ++i) {
        if (!c[i]) primes[j++] = i;
    }
    pair orm30[30];
    int counts[5];
    j = 100000;
    for (i = 0; i < pc-1; ++i) {
        p1 = primes[i];
        p2 = primes[i+1];
        if ((p2 - p1) % 18) continue;
        key1 = 1;
        d = getDigits(p1);
        for (k = 0; k < d.count; ++k) key1 *= primes[d.digs[k]];
        key2 = 1;
        d = getDigits(p2);
        for (k = 0; k < d.count; ++k) key2 *= primes[d.digs[k]];
        if (key1 == key2) {
            if (count < 30) orm30[count] = (pair){p1, p2};
            if (p1 >= j) {
                counts[count2++] = count;
                j *= 10;
            }
            ++count;
        }
    }
    counts[count2] = count;
    printf("First 30 Ormiston pairs:\n");
    setlocale(LC_NUMERIC, "");
    for (i = 0; i < 30; ++i) {
        printf("[%'6d, %'6d] ", orm30[i].x, orm30[i].y);
        if (!((i+1) % 3)) printf("\n");
    }
    printf("\n");
    j = 100000;
    for (i = 0; i < 5; ++i) {
        printf("%'d Ormiston pairs before %'d\n", counts[i], j);
        j *= 10;
    }
    free(c);
    free(primes);
    return 0;
}
