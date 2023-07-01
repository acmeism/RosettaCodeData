#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

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

void longestSeq(int *primes, int pc, bool asc) {
    int i, j, d, pd = 0, lls = 1, lcs = 1;
    int longSeqs[25][10] = {{2}};
    int lsl[25] = {1};
    int currSeq[10] = {2};
    const char *dir = asc ? "ascending" : "descending";
    for (i = 1; i < pc; ++i) {
        d = primes[i] - primes[i-1];
        if ((asc && d <= pd) || (!asc && d >= pd)) {
            if (lcs > lsl[0]) {
                memcpy((void *)longSeqs[0], (void *)currSeq, lcs * sizeof(int));
                lsl[0] = lcs;
                lls = 1;
            } else if (lcs == lsl[0]) {
                memcpy((void *)longSeqs[lls], (void *)currSeq, lcs * sizeof(int));
                lsl[lls++] = lcs;
            }
            currSeq[0] = primes[i-1];
            currSeq[1] = primes[i];
            lcs = 2;
        } else {
            currSeq[lcs++] = primes[i];
        }
        pd = d;
    }
    if (lcs > lsl[0]) {
        memcpy((void *)longSeqs[0], (void *)currSeq, lcs * sizeof(int));
        lsl[0] = lcs;
        lls = 1;
    } else if (lcs == lsl[0]) {
        memcpy((void *)longSeqs[lls], (void *)currSeq, lcs * sizeof(int));
        lsl[lls++] = lcs;
    }
    printf("Longest run(s) of primes with %s differences is %d:\n", dir, lsl[0]);
    for (i = 0; i < lls; ++i) {
        int *ls = longSeqs[i];
        for (j = 0; j < lsl[i]-1; ++j) printf("%d (%d) ", ls[j], ls[j+1] - ls[j]);
        printf("%d\n", ls[lsl[i]-1]);
    }
    printf("\n");
}

int main() {
    const int limit = 999999;
    int i, j, pc = 0;
    bool *c = sieve(limit);
    for (i = 0; i < limit; ++i) {
        if (!c[i]) ++pc;
    }
    int *primes = (int *)malloc(pc * sizeof(int));
    for (i = 0, j = 0; i < limit; ++i) {
        if (!c[i]) primes[j++] = i;
    }
    free(c);
    printf("For primes < 1 million:\n");
    longestSeq(primes, pc, true);
    longestSeq(primes, pc, false);
    free(primes);
    return 0;
}
