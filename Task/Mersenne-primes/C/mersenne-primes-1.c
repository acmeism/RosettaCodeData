#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

bool isPrime(uint64_t n) {
    uint64_t test;

    if (n < 2) return false;
    if (n % 2 == 0) return n == 2;
    if (n % 3 == 0) return n == 3;

    test = 5;
    while (test * test < n) {
        if (n % test == 0) return false;
        test += 2;
        if (n % test == 0) return false;
        test += 4;
    }

    return true;
}

int main() {
    uint64_t base = 2;
    int pow;

    for (pow = 1; pow <= 32; pow++) {
        if (isPrime(base - 1)) {
            printf("2 ^ %d - 1\n", pow);
        }
        base *= 2;
    }

    return 0;
}
