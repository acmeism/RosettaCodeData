#include <stdio.h>

// See https://en.wikipedia.org/wiki/Divisor_function
unsigned int divisor_sum(unsigned int n) {
    unsigned int total = 1, power = 2;
    unsigned int p;
    // Deal with powers of 2 first
    for (; (n & 1) == 0; power <<= 1, n >>= 1) {
        total += power;
    }
    // Odd prime factors up to the square root
    for (p = 3; p * p <= n; p += 2) {
        unsigned int sum = 1;
        for (power = p; n % p == 0; power *= p, n /= p) {
            sum += power;
        }
        total *= sum;
    }
    // If n > 1 then it's prime
    if (n > 1) {
        total *= n + 1;
    }
    return total;
}

int main() {
    const unsigned int limit = 100;
    unsigned int n;
    printf("Sum of divisors for the first %d positive integers:\n", limit);
    for (n = 1; n <= limit; ++n) {
        printf("%4d", divisor_sum(n));
        if (n % 10 == 0) {
            printf("\n");
        }
    }
    return 0;
}
