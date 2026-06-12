#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <locale.h>

#define LIMIT 5000000

typedef struct {
    int x;
    int y;
} pair;

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

int digitSum(int n) {
    int sum = 0;
    while (n > 0) {
        sum += n % 10;
        n /= 10;
    }
    return sum;
}

int main() {
    int i, count, length, hc = 0;
    int *primes = (int *)primeSieve(LIMIT, &length);
    pair h[50], h10000;
    for (i = 1, count = 0; count < 10000; ++i) {
        if (digitSum(i) == digitSum(primes[i-1])) {
            ++count;
            if (count <= 50) {
                h[hc++] = (pair){i, primes[i-1]};
            } else if (count == 10000) {
                h10000.x = i;
                h10000.y = primes[i-1];
            }
        }
    }
    setlocale(LC_NUMERIC, "");
    printf("The first 50 Honaker primes (index, prime):\n");
    for (i = 0; i < 50; ++i) {
        printf("(%3d, %'5d) ", h[i].x, h[i].y);
        if (!((i+1)%5)) printf("\n");
    }
    printf("\nand the 10,000th: (%'7d, %'9d)\n", h10000.x, h10000.y);
    free(primes);
    return 0;
}
