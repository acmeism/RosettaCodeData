#include <stdio.h>

unsigned modpow(unsigned b, unsigned e, unsigned m)
{
    unsigned p;
    for (p = 1; e; e >>= 1) {
        if (e & 1)
            p = p * b % m;
        b = b * b % m;
    }
    return p;
}

int is_deceptive(unsigned n)
{
    unsigned x;
    if (n & 1 && n % 3 && n % 5) {
        for (x = 7; x * x <= n; x += 6) {
            if (!(n % x && n % (x + 4)))
                return modpow(10, n - 1, n) == 1;
        }
    }
    return 0;
}

int main(void)
{
    unsigned c, i = 49;
    for (c = 0; c != 50; ++i) {
        if (is_deceptive(i)) {
            printf(" %u", i);
            ++c;
        }
    }
    return 0;
}
