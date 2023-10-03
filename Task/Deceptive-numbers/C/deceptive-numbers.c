#include <inttypes.h>
#include <stdio.h>

uint32_t modpow(uint32_t b, uint32_t e, uint32_t m)
{
    uint32_t p;
    for (p = 1; e; e >>= 1) {
        if (e & 1)
            p = (uint64_t)p * b % m;
        b = (uint64_t)b * b % m;
    }
    return p;
}

int is_deceptive(uint32_t n)
{
    uint32_t x;
    if (n & 1 && n % 3 && n % 5 && modpow(10, n - 1, n) == 1) {
        for (x = 7; x * x <= n; x += 6) {
            if (!(n % x && n % (x + 4)))
                return 1;
        }
    }
    return 0;
}

int main(void)
{
    uint32_t n = 49;
    unsigned int c;
    for (c = 0; c != 500; ++n) {
        if (is_deceptive(n)) {
            printf(" %" PRIu32, n);
            ++c;
        }
    }
    return 0;
}
