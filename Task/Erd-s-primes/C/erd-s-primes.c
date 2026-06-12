#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <locale.h>

#define LIMIT 1000000
#define LOWER_LIMIT 2500

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

int main() {
    int i, j, fact, ec = 0, ec2 = 0, lastErdos = 0;
    bool found;
    bool *c = sieve(LIMIT-1);
    int erdos[30];
    for (i = 2; i < LIMIT;) {
        if (!c[i]) {
            j = 1;
            fact = 1;
            found = true;
            while (fact < i) {
                if (!c[i-fact]) {
                    found = false;
                    break;
                }
                ++j;
                fact *= j;
            }
            if (found) {
                if (i < LOWER_LIMIT) erdos[ec2++] = i;
                lastErdos = i;
                ++ec;
            }
        }
        i = (i > 2) ? i + 2 : i + 1;
    }
    setlocale(LC_NUMERIC, "");
    printf("The %'d Erdős primes under %'d are:\n", ec2, LOWER_LIMIT);
    for (i = 0; i < ec2; ++i) {
        printf("%6d ", erdos[i]);
        if (!((i+1)%10)) printf("\n");
    }
    printf("\n\nThe %'dth Erdős prime is %'d.\n", ec, lastErdos);
    free(c);
    return 0;
}
