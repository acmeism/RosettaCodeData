#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define LIMIT 6000

char *primes(unsigned int limit) {
    char *p = malloc(limit + 1);
    int i, j, sqr = sqrt(limit);

    p[0] = p[1] = 0;
    memset(p+2, 1, limit-1);
    for (i=2; i<=sqr; i++)
        if (p[i])
            for (j=i*2; j<=limit; j+=i)
                p[j] = 0;

    return p;
}

int triplet(const char *p, unsigned int n) {
    return n >= 2 && p[n-1] && p[n+3] && p[n+5];
}

int main() {
    char *p = primes(LIMIT+5);
    int i;

    for (i=2; i<LIMIT; i++)
        if (triplet(p, i))
            printf("%4d: %4d, %4d, %4d\n", i, i-1, i+3, i+5);

    free(p);
    return 0;
}
