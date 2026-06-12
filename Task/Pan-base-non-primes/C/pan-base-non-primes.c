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
    if (n % 5 == 0)
        return n == 5;
    static const uint64_t wheel[] = {4, 2, 4, 2, 4, 6, 2, 6};
    for (uint64_t p = 7;;) {
        for (int i = 0; i < 8; ++i) {
            if (p * p > n)
                return true;
            if (n % p == 0)
                return false;
            p += wheel[i];
        }
    }
}

// Compute the digits of n in base 10, least significant digit first.
int digits(uint64_t n, uint8_t* d, int size) {
    int count = 0;
    for (; n > 0 && size > 0; n /= 10, --size, ++count)
        *d++ = n % 10;
    return count;
}

// Convert digits in the given base to a number (least significant digit first).
uint64_t from_digits(uint8_t* a, int count, uint64_t base) {
    uint64_t n = 0;
    while (count-- > 0)
        n = n * base + a[count];
    return n;
}

#define MAX_DIGITS 20

bool is_pan_base_non_prime(uint64_t n) {
    if (n < 10)
        return !is_prime(n);
    if (n > 10 && n % 10 == 0)
        return true;
    uint8_t d[MAX_DIGITS];
    int count = digits(n, d, MAX_DIGITS);
    uint8_t max_digit = 0;
    for (int i = 0; i < count; ++i) {
        if (max_digit < d[i])
            max_digit = d[i];
    }
    for (uint64_t base = max_digit + 1; base <= n; ++base) {
        if (is_prime(from_digits(d, count, base)))
            return false;
    }
    return true;
}

int main() {
    printf("First 50 prime pan-base composites:\n");
    int count = 0;
    for (uint64_t n = 2; count < 50; ++n) {
        if (is_pan_base_non_prime(n)) {
            ++count;
            printf("%3llu%c", n, count % 10 == 0 ? '\n' : ' ');
        }
    }

    printf("\nFirst 20 odd prime pan-base composites:\n");
    count = 0;
    for (uint64_t n = 3; count < 20; n += 2) {
        if (is_pan_base_non_prime(n)) {
            ++count;
            printf("%3llu%c", n, count % 10 == 0 ? '\n' : ' ');
        }
    }

    const uint64_t limit = 10000;
    int odd = 0;
    count = 0;
    for (uint64_t n = 2; n <= limit; ++n) {
        if (is_pan_base_non_prime(n)) {
            ++count;
            if (n % 2 == 1)
                ++odd;
        }
    }

    printf("\nCount of pan-base composites up to and including %llu: %d\n",
           limit, count);
    double percent = 100.0 * odd / count;
    printf("Percent odd  up to and including %llu: %f\n", limit, percent);
    printf("Percent even up to and including %llu: %f\n", limit,
           100.0 - percent);

    return 0;
}
