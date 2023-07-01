#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <locale.h>

bool *sieve(uint64_t limit) {
    uint64_t i, p;
    limit++;
    // True denotes composite, false denotes prime.
    bool *c = calloc(limit, sizeof(bool)); // all false by default
    c[0] = true;
    c[1] = true;
    for (i = 4; i < limit; i += 2) c[i] = true;
    p = 3; // Start from 3.
    while (true) {
        uint64_t p2 = p * p;
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

digits getDigits(uint64_t n) {
    if (n == 0) return (digits){ {0}, 1 };
    digits d;
    d.count = 0;
    while (n > 0) {
        d.digs[d.count++] = n % 10;
        n = n / 10;
    }
    return d; // note digits are in reverse order
}

int main() {
    const uint64_t limit = 10000000000;
    uint64_t i, j, pc = 0, p1, p2, p3, key1, key2, key3;
    int k, count, count2;
    digits d;
    bool *c = sieve(limit);
    for (i = 0; i < limit; ++i) {
        if (!c[i]) ++pc;
    }
    uint64_t *primes = (uint64_t *)malloc(pc * sizeof(uint64_t));
    for (i = 0, j = 0; i < limit; ++i) {
        if (!c[i]) primes[j++] = i;
    }
    free(c);
    uint64_t orm25[25];
    int counts[2];
    j = limit/10;
    for (i = 0; i < pc-2; ++i) {
        p1 = primes[i];
        p2 = primes[i+1];
        p3 = primes[i+2];
        if ((p2 - p1) % 18 || (p3 - p2) % 18) continue;
        key1 = 1;
        d = getDigits(p1);
        for (k = 0; k < d.count; ++k) key1 *= primes[d.digs[k]];
        key2 = 1;
        d = getDigits(p2);
        for (k = 0; k < d.count; ++k) key2 *= primes[d.digs[k]];
        if (key1 != key2) continue;
        key3 = 1;
        d = getDigits(p3);
        for (k = 0; k < d.count; ++k) key3 *= primes[d.digs[k]];
        if (key2 == key3) {
            if (count < 25) orm25[count] = p1;
            if (p1 >= j) {
                counts[count2++] = count;
                j *= 10;
            }
            ++count;
        }
    }
    counts[count2] = count;
    printf("Smallest members of first 25 Ormiston triples:\n");
    setlocale(LC_NUMERIC, "");
    for (i = 0; i < 25; ++i) {
        printf("%'10ld  ", orm25[i]);
        if (!((i+1) % 5)) printf("\n");
    }
    printf("\n");
    j = limit/10;
    for (i = 0; i < 2; ++i) {
        printf("%'d Ormiston triples before %'ld\n", counts[i], j);
        j *= 10;
        printf("\n");
    }
    free(primes);
    return 0;
}
