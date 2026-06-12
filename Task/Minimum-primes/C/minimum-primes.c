#include <stdio.h>

#define TRUE 1
#define FALSE 0

int isPrime(int n) {
    int d;
    if (n < 2) return FALSE;
    if (n%2 == 0) return n == 2;
    if (n%3 == 0) return n == 3;
    d = 5;
    while (d*d <= n) {
        if (!(n%d)) return FALSE;
        d += 2;
        if (!(n%d)) return FALSE;
        d += 4;
    }
    return TRUE;
}

int max(int a, int b) {
    if (a > b) return a;
    return b;
}

int main() {
    int n, m;
    int numbers1[5] = { 5, 45, 23, 21, 67};
    int numbers2[5] = {43, 22, 78, 46, 38};
    int numbers3[5] = { 9, 98, 12, 54, 53};
    int primes[5]   = {};
    for (n = 0; n < 5; ++n) {
        m = max(max(numbers1[n], numbers2[n]), numbers3[n]);
        if (!(m % 2)) m++;
        while (!isPrime(m)) m += 2;
        primes[n] = m;
        printf("%d ", primes[n]);
    }
    printf("\n");
    return 0;
}
