#include <stdio.h>
#include <stdlib.h>

#define TRUE 1
#define FALSE 0

typedef int bool;

void sieve(int limit, int primes[], int *count) {
    bool *c = calloc(limit + 1, sizeof(bool)); /* composite = TRUE */
    /* no need to process even numbers */
    int i, p = 3, p2, n = 0;
    p2 = p * p;
    while (p2 <= limit) {
        for (i = p2; i <= limit; i += 2 * p)
            c[i] = TRUE;
        do {
            p += 2;
        } while (c[p]);
        p2 = p * p;
    }
    for (i = 3; i <= limit; i += 2) {
        if (!c[i]) primes[n++] = i;
    }
    *count = n;
    free(c);
}

/* finds the period of the reciprocal of n */
int findPeriod(int n) {
    int i, r = 1, rr, period = 0;
    for (i = 1; i <= n + 1; ++i) {
        r = (10 * r) % n;
    }
    rr = r;
    do {
        r = (10 * r) % n;
        period++;
    } while (r != rr);
    return period;
}

int main() {
    int i, prime, count = 0, index = 0, primeCount, longCount = 0, numberCount;
    int *primes, *longPrimes, *totals;
    int numbers[] = {500, 1000, 2000, 4000, 8000, 16000, 32000, 64000};

    primes = calloc(6500, sizeof(int));
    numberCount = sizeof(numbers) / sizeof(int);
    totals = calloc(numberCount, sizeof(int));
    sieve(64000, primes, &primeCount);
    longPrimes = calloc(primeCount, sizeof(int));
    /* Surely longCount < primeCount */
    for (i = 0; i < primeCount; ++i) {
        prime = primes[i];
        if (findPeriod(prime) == prime - 1) {
            longPrimes[longCount++] = prime;
        }
    }
    for (i = 0; i < longCount; ++i, ++count) {
        if (longPrimes[i] > numbers[index]) {
            totals[index++] = count;
        }
    }
    totals[numberCount - 1] = count;
    printf("The long primes up to %d are:\n", numbers[0]);
    printf("[");
    for (i = 0; i < totals[0]; ++i) {
        printf("%d ", longPrimes[i]);
    }
    printf("\b]\n");

    printf("\nThe number of long primes up to:\n");
    for (i = 0; i < 8; ++i) {
        printf("  %5d is %d\n", numbers[i], totals[i]);
    }
    free(totals);
    free(longPrimes);
    free(primes);
    return 0;
}
