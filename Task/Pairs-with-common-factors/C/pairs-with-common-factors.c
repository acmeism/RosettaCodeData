#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <locale.h>

#define MAX 1000000

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

uint64_t totient(uint64_t n) {
    uint64_t tot = n, i = 2;
    while (i*i <= n) {
        if (!(n%i)) {
            do {n /= i;} while (!(n%i));
            tot -= tot/i;
        }
        if (i == 2) i = 1;
        i += 2;
    }
    if (n > 1) tot -= tot/n;
    return tot;
}

const char *ord(int c) {
    int m = c % 100;
    if (m >= 4 && m <= 20) return "th";
    m %= 10;
    return (m == 1) ? "st" :
           (m == 2) ? "nd" :
           (m == 3) ? "rd" : "th";
}

int main() {
    uint64_t n, sumPhi = 0, *a = (uint64_t *)calloc(MAX, sizeof(uint64_t));
    int i, limit;
    for (n = 1; n <= MAX; ++n) {
        sumPhi += totient(n);
        if (isPrime(n)) {
            a[n-1] = a[n-2];
        } else {
            a[n-1] = n*(n-1)/2 + 1 - sumPhi;
        }
    }
    setlocale(LC_NUMERIC, "");
    printf("Number of pairs with common factors - first one hundred terms:\n");
    for (i = 0; i < 100; ++i) {
        printf("%'5lu  ", a[i]);
        if (!((i+1)%10)) printf("\n");
    }
    printf("\n");
    for (limit = 1; limit <= MAX; limit *= 10) {
        printf("The %'d%s term: %'lu\n", limit, ord(limit), a[limit-1]);
    }
    free(a);
    return 0;
}
