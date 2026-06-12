#include <stdio.h>
#include <string.h>

#define LIMIT 1000

void sieve(int max, char *s) {
    int p, k;
    memset(s, 0, max);
    for (p=2; p*p<=max; p++)
        if (!s[p])
            for (k=p*p; k<=max; k+=p)
                s[k]=1;
}

int main(void) {
    char primes[LIMIT+1];
    int p, count=0;

    sieve(LIMIT, primes);
    for (p=2; p<=LIMIT; p++) {
        if (!primes[p] && !primes[p+4]) {
            count++;
            printf("%4d: %4d\n", p, p+4);
        }
    }

    printf("There are %d cousin prime pairs below %d.\n", count, LIMIT);
    return 0;
}
