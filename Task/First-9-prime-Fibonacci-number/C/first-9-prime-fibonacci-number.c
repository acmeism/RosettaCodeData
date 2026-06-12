#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

bool isPrime(uint64_t n) {
    if (n < 2) return false;
    if (!(n%2)) return n == 2;
    if (!(n%3)) return n == 3;
    uint64_t d = 5;
    while (d*d <= n) {
        if (!(n%d)) return false;
        d += 2;
        if (!(n%d)) return false;
        d += 4;
    }
    return true;
}

int main() {
    uint64_t f1 = 1, f2 = 1, f3;
    int count = 0, limit = 12; // as far as we can get without using GMP
    printf("The first %d prime Fibonacci numbers are:\n", limit);
    while (count < limit) {
        f3 = f1 + f2;
        if (isPrime(f3)) {
            printf("%ld ", f3);
            count++;
        }
        f1 = f2;
        f2 = f3;
    }
    printf("\n");
    return 0;
}
