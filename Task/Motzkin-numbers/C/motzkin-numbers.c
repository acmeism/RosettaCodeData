#include <locale.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

bool is_prime(uint64_t n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    for (uint64_t p = 5; p * p <= n; p += 4) {
        if (n % p == 0)
            return false;
        p += 2;
        if (n % p == 0)
            return false;
    }
    return true;
}

int main() {
    setlocale(LC_ALL, "");
    printf(" n          M(n)             Prime?\n");
    printf("-----------------------------------\n");
    uint64_t m0 = 1, m1 = 1;
    for (uint64_t i = 0; i < 42; ++i) {
        uint64_t m =
            i > 1 ? (m1 * (2 * i + 1) + m0 * (3 * i - 3)) / (i + 2) : 1;
        printf("%2llu%'25llu  %s\n", i, m, is_prime(m) ? "true" : "false");
        m0 = m1;
        m1 = m;
    }
}
