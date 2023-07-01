#include <stdio.h>

unsigned int divisor_count(unsigned int n) {
    unsigned int total = 1;
    unsigned int p;

    // Deal with powers of 2 first
    for (; (n & 1) == 0; n >>= 1) {
        ++total;
    }
    // Odd prime factors up to the square root
    for (p = 3; p * p <= n; p += 2) {
        unsigned int count = 1;
        for (; n % p == 0; n /= p) {
            ++count;
        }
        total *= count;
    }
    // If n > 1 then it's prime
    if (n > 1) {
        total *= 2;
    }
    return total;
}

int main() {
    const unsigned int limit = 100;
    unsigned int count = 0;
    unsigned int n;

    printf("The first %d tau numbers are:\n", limit);
    for (n = 1; count < limit; ++n) {
        if (n % divisor_count(n) == 0) {
            printf("%6d", n);
            ++count;
            if (count % 10 == 0) {
                printf("\n");
            }
        }
    }

    return 0;
}
