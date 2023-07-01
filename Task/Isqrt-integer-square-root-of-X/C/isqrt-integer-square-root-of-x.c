#include <stdint.h>
#include <stdio.h>

int64_t isqrt(int64_t x) {
    int64_t q = 1, r = 0;
    while (q <= x) {
        q <<= 2;
    }
    while (q > 1) {
        int64_t t;
        q >>= 2;
        t = x - r - q;
        r >>= 1;
        if (t >= 0) {
            x = t;
            r += q;
        }
    }
    return r;
}

int main() {
    int64_t p;
    int n;

    printf("Integer square root for numbers 0 to 65:\n");
    for (n = 0; n <= 65; n++) {
        printf("%lld ", isqrt(n));
    }
    printf("\n\n");

    printf("Integer square roots of odd powers of 7 from 1 to 21:\n");
    printf(" n |              7 ^ n | isqrt(7 ^ n)\n");
    p = 7;
    for (n = 1; n <= 21; n += 2, p *= 49) {
        printf("%2d | %18lld | %12lld\n", n, p, isqrt(p));
    }
}
