#include <math.h>
#include <stdio.h>

// See https://en.wikipedia.org/wiki/Divisor_function
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

// See https://mathworld.wolfram.com/DivisorProduct.html
unsigned int divisor_product(unsigned int n) {
    return pow(n, divisor_count(n) / 2.0);
}

int main() {
    const unsigned int limit = 50;
    unsigned int n;

    printf("Product of divisors for the first %d positive integers:\n", limit);
    for (n = 1; n <= limit; ++n) {
        printf("%11d", divisor_product(n));
        if (n % 5 == 0) {
            printf("\n");
        }
    }

    return 0;
}
