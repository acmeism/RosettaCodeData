#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>

int64_t largestPrimeFactor(int64_t n) {
    int64_t p, res;

    if (n <= 1) return n;
    for (p = 2; p * p <= n; p++) {
        if (n % p == 0) res = p;
        while(n % p == 0) n /= p;
    }
    if (n != 1) res = n;
    return res;
}

int64_t factorialPrimeExponent(int64_t k, int64_t p) {
    int64_t res = 0;
    while (k > 0) {
         k = k / p;
         res += k;
    }
    return res;
}

bool factorialDivisibleByNumber(int64_t kFac, int64_t n) {
    int64_t p, e;

    for (p = 2; p * p <= n; p++) {
        for (e = 0; n % p == 0; n /= p)
            e++;

        if (factorialPrimeExponent(kFac, p) < e)
            return false;
    }
    if (n != 1) {
        e = 1;
        if (factorialPrimeExponent(kFac, n) < e)
            return false;
    }
    return true;
}

int64_t kempner(int64_t n) {
    int64_t k;

    if (n == 1) return 1;
    k = largestPrimeFactor(n);
    while (!factorialDivisibleByNumber(k, n)) k++;
    return k;
}

int main() {
    int64_t n;

    printf("First fifty Kempner numbers:\n");
    for (n = 1; n <= 50; n++) {
        printf("%4d ", kempner(n));
        if (n % 10 == 0)
            printf("\n");
    }

    printf("\n");
    for (n = 77135679311; n <= 77135679321; n++)
        printf("S(%ld) = %ld\n", n, kempner(n));

    return 0;
}
