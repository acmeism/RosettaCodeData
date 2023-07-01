#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <locale.h>

uint64_t modPow(uint64_t base, uint64_t exp, uint64_t mod) {
    if (mod == 1) return 0;
    uint64_t result = 1;
    base %= mod;
    for (; exp > 0; exp >>= 1) {
        if ((exp & 1) == 1) result = (result * base) % mod;
        base = (base * base) % mod;
    }
    return result;
}

bool isCurzon(uint64_t n, uint64_t k) {
    const uint64_t r = k * n;
    return modPow(k, n, r+1) == r;
}

int main() {
    uint64_t k, n, count;
    setlocale(LC_NUMERIC, "");
    for (k = 2; k <= 10; k += 2) {
        printf("Curzon numbers with base %ld:\n", k);
        for (n = 1, count = 0; count < 50; ++n) {
            if (isCurzon(n, k)) {
                printf("%4ld ", n);
                if (++count % 10 == 0) printf("\n");
            }
        }
        for (;;) {
            if (isCurzon(n, k)) ++count;
            if (count == 1000) break;
            ++n;
        }
        printf("1,000th Curzon number with base %ld: %'ld\n\n", k, n);
    }
    return 0;
}
