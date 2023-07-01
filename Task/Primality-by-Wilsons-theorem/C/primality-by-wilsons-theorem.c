#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

uint64_t factorial(uint64_t n) {
    uint64_t product = 1;

    if (n < 2) {
        return 1;
    }

    for (; n > 0; n--) {
        uint64_t prev = product;
        product *= n;
        if (product < prev) {
            fprintf(stderr, "Overflowed\n");
            return product;
        }
    }

    return product;
}

// uses wilson's theorem
bool isPrime(uint64_t n) {
    uint64_t large = factorial(n - 1) + 1;
    return (large % n) == 0;
}

int main() {
    uint64_t n;

    // Can check up to 21, more will require a big integer library
    for (n = 2; n < 22; n++) {
        printf("Is %llu prime: %d\n", n, isPrime(n));
    }

    return 0;
}
