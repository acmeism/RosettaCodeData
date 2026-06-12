#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <locale.h>

bool isPrime(int n) {
    if (n < 2) return false;
    if (n%2 == 0) return n == 2;
    if (n%3 == 0) return n == 3;
    int d = 5;
    while (d*d <= n) {
        if (n%d == 0) return false;
        d += 2;
        if (n%d == 0) return false;
        d += 4;
    }
    return true;
}

int compare(const void* a, const void* b) {
    int arg1 = *(const int*)a;
    int arg2 = *(const int*)b;
    if (arg1 < arg2) return -1;
    if (arg1 > arg2) return 1;
    return 0;
}

int main() {
    int primes[30] = {2}, results[200];
    int i, j, p, q, pq, limit = 100, pc = 1, rc = 0;
    for (i = 3; i < limit; i += 2) {
        if (isPrime(i)) primes[pc++] = i;
    }
    for (i = 0; i < pc; ++i) {
        p = primes[i];
        for (j = 0; j < pc; ++j) {
            q = primes[j];
            pq = (q < 10) ? p * 10 + q : p * 100 + q;
            if (isPrime(pq)) results[rc++] = pq;
        }
    }
    qsort(results, rc, sizeof(int), compare);
    setlocale(LC_NUMERIC, "");
    printf("Two primes under 100 concatenated together to form another prime:\n");
    for (i = 0, j = 0; i < rc; ++i) {
        if (i > 0 && results[i] == results[i-1]) continue;
        printf("%'6d ", results[i]);
        if (++j % 10 == 0) printf("\n");
    }
    printf("\n\nFound %d such concatenated primes.\n", j);
    return 0;
}
