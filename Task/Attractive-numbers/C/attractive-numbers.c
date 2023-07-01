#include <stdio.h>

#define TRUE 1
#define FALSE 0
#define MAX 120

typedef int bool;

bool is_prime(int n) {
    int d = 5;
    if (n < 2) return FALSE;
    if (!(n % 2)) return n == 2;
    if (!(n % 3)) return n == 3;
    while (d *d <= n) {
        if (!(n % d)) return FALSE;
        d += 2;
        if (!(n % d)) return FALSE;
        d += 4;
    }
    return TRUE;
}

int count_prime_factors(int n) {
    int count = 0, f = 2;
    if (n == 1) return 0;
    if (is_prime(n)) return 1;
    while (TRUE) {
        if (!(n % f)) {
            count++;
            n /= f;
            if (n == 1) return count;
            if (is_prime(n)) f = n;
        }
        else if (f >= 3) f += 2;
        else f = 3;
    }
}

int main() {
    int i, n, count = 0;
    printf("The attractive numbers up to and including %d are:\n", MAX);
    for (i = 1; i <= MAX; ++i) {
        n = count_prime_factors(i);
        if (is_prime(n)) {
            printf("%4d", i);
            if (!(++count % 20)) printf("\n");
        }
    }
    printf("\n");
    return 0;
}
