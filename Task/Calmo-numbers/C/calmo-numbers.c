#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define LIMIT 1000

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

void eligibleDivisors(int n, int *divs, int *length) {
    if (n < 1) {
        *length = 0;
        return;
    }
    int i, j, k = 1, c = 0;
    if (n%2) k = 2;
    for (i = k + 1; i*i <= n; i += k) {
        if (!(n%i)) {
           divs[c++] = i;
           j = n / i;
           if (j != i) divs[c++] = j;
        }
    }
    if (c > 1) qsort(divs, c, sizeof(int), compare);
    *length = c;
}

int main() {
    int i, j, sum, edc, psc, cnc = 0;
    int ed[30], ps[5];
    bool isCalmo;
    printf("Calmo numbers under 1,000:\n");
    printf("Number  Eligible divisors           Partial sums\n");
    printf("------------------------------------------------\n");
    for (i = 2; i < LIMIT; ++i) {
        eligibleDivisors(i, ed, &edc);
        if (edc == 0 || edc % 3 != 0 ) continue;
        isCalmo = true;
        psc = 0;
        for (j = 0; j < edc; j += 3) {
            sum = ed[j] + ed[j+1] + ed[j+2];
            if (!isPrime(sum)) {
                isCalmo = false;
                break;
            }
            ps[psc++] = sum;
        }
        if (isCalmo) {
            printf("%3d     [", i);
            for (j = 0; j < edc; ++j) printf("%d, ", ed[j]);
            printf("\b\b]  \t\b\b\b\b[");
            for (j = 0; j < psc; ++j) printf("%d, ", ps[j]);
            printf("\b\b]\n");
        }
    }
    return 0;
}
