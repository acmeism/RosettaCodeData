#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <gmp.h>

#define MAX 23

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
    uint64_t p = 2;
    int count = 0;
    mpz_t m, one;
    mpz_init(m);
    mpz_init_set_ui(one, 1);
    while (true) {
        mpz_mul_2exp(m, one, p);
        mpz_sub_ui(m, m, 1);
        if (mpz_probab_prime_p(m, 15) > 0) {
            printf("2 ^ %ld - 1\n", p);
            if (++count == MAX) break;
        }
        while (true) {
            p = (p > 2) ? p + 2 : 3;
            if (isPrime(p)) break;
        }
    }
    mpz_clear(m);
    mpz_clear(one);
    return 0;
}
