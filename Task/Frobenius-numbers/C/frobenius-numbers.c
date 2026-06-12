#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define LIMIT 10000

/* Generate primes up to N */
unsigned int sieve(unsigned int n, unsigned int **list) {
    unsigned char *sieve = calloc(n+1, 1);
    unsigned int i, j, max = 0;
    for (i = 2; i*i <= n; i++)
        if (!sieve[i])
            for (j = i+i; j <= n; j += i)
                sieve[j] = 1;
    for (i = 2; i <= n; i++) max += !sieve[i];
    *list = malloc(max * sizeof(unsigned int));
    for (i = 0, j = 2; j <= n; j++)
        if (!sieve[j]) (*list)[i++] = j;
    free(sieve);
    return i;
}

/* Frobenius number */
unsigned int frob(unsigned const int *primes, unsigned int n) {
    return primes[n] * primes[n+1] - primes[n] - primes[n+1];
}

int main() {
    /* Same trick as in BCPL example. frob(n) < primes(n+1)^2,
       so we need primes up to sqrt(limit)+1. */
    unsigned int *primes;
    unsigned int amount = sieve(sqrt(LIMIT)+1, &primes);
    unsigned int i;

    for (i=0; i<amount-1; i++) printf("%d\n", frob(primes, i));
    free(primes);

    return 0;
}
