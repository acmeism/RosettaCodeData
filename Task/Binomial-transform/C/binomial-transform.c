#include <stdio.h>
#include <stdint.h>

uint64_t factorial(int n) {
    if (n > 20) return 0; // too big for uint64_t
    if (n < 2) return 1;
    uint64_t fact = 1;
    int i = 2;
    for (i = 2; i <= n; ++i) fact *= i;
    return fact;
}

uint64_t binomial(int n, int k) {
    return factorial(n) / factorial(n-k) / factorial(k);
}

void btForward(int64_t b[], const int64_t a[], size_t c) {
    int n, k;
    for (n = 0; n < c; ++n) {
        b[n] = 0;
        for (k = 0; k <= n; ++k) {
            b[n] += (int64_t)binomial(n, k) * a[k];
        }
    }
}

void btInverse(int64_t a[], const int64_t b[], size_t c) {
    int n, k, sign;
    for (n = 0; n < c; ++n) {
        a[n] = 0;
        for (k = 0; k <= n; ++k) {
            sign = (n-k) & 1 ? -1 : 1;
            a[n] += (int64_t)binomial(n, k) * b[k] * sign;
        }
    }
}

void btSelfInverting(int64_t b[], const int64_t a[], size_t c) {
    int n, k, sign;
    for (n = 0; n < c; ++n) {
        b[n] = 0;
        for (k = 0; k <= n; ++k) {
            sign = k & 1 ? -1 : 1;
            b[n] += (int64_t)binomial(n, k) * a[k] * sign;
        }
    }
}

int main() {
    int i, j;
    int64_t fwd[20], res[20], seqs[4][20] = {
        {1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845, 35357670, 129644790, 477638700, 1767263190},
        {0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0},
        {0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181},
        {1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37}
    };

    const char *names[4] = {
        "Catalan number sequence:",
        "Prime flip-flop sequence:",
        "Fibonacci number sequence:",
        "Padovan number sequence:"
    };

    for (i = 0; i < 4; ++i) {
        printf("%s\n", names[i]);
        for (j = 0; j < 20; ++j) printf("%ld ", seqs[i][j]);
        printf("\nForward binomial transform:\n");
        btForward(fwd, seqs[i], 20);
        for (j = 0; j < 20; ++j) printf("%ld ", fwd[j]);
        printf("\nInverse binomial transform:\n");
        btInverse(res, seqs[i], 20);
        for (j = 0; j < 20; ++j) printf("%ld ", res[j]);
        printf("\nRound trip:\n");
        btInverse(res, fwd, 20);
        for (j = 0; j < 20; ++j) printf("%ld ", res[j]);
        printf("\nSelf-inverting:\n");
        btSelfInverting(fwd, seqs[i], 20);
        for (j = 0; j < 20; ++j) printf("%ld ", fwd[j]);
        printf("\nRe-inverted:\n");
        btSelfInverting(res, fwd, 20);
        for (j = 0; j < 20; ++j) printf("%ld ", res[j]);
        if (i < 3) printf("\n\n"); else printf("\n");
    }
    return 0;
}
