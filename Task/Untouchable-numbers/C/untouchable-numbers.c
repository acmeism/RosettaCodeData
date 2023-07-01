#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <locale.h>

bool *primeSieve(int limit) {
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
    const int limit = 1000000;
    int i, j, n, uc = 2, p = 10, m = 63, ul = 151000;
    bool *c = primeSieve(limit);
    n = m * limit + 1;
    int *sumDivs = (int *)calloc(n, sizeof(int));
    for (i = 1; i < n; ++i) {
        for (j = i; j < n; j += i) sumDivs[j] += i;
    }
    bool *s = (bool *)calloc(n, sizeof(bool)); // all false
    for (i = 1; i < n; ++i) {
        int sum = sumDivs[i] - i; // proper divs sum
        if (sum <= n) s[sum] = true;
    }
    free(sumDivs);
    int *untouchable = (int *)malloc(ul * sizeof(int));
    untouchable[0] = 2;
    untouchable[1] = 5;
    for (n = 6; n <= limit; n += 2) {
        if (!s[n] && c[n-1] && c[n-3]) untouchable[uc++] = n;
    }
    setlocale(LC_NUMERIC, "");
    printf("List of untouchable numbers <= 2,000:\n");
    for (i = 0; i < uc; ++i) {
        j = untouchable[i];
        if (j > 2000) break;
        printf("%'6d ", j);
        if (!((i+1) % 10)) printf("\n");
    }
    printf("\n\n%'7d untouchable numbers were found  <=     2,000\n", i);
    for (i = 0; i < uc; ++i) {
        j = untouchable[i];
        if (j > p) {
            printf("%'7d untouchable numbers were found  <= %'9d\n", i, p);
            p *= 10;
            if (p == limit) break;
        }
    }
    printf("%'7d untouchable numbers were found  <= %'d\n", uc, limit);
    free(c);
    free(s);
    free(untouchable);
    return 0;
}
